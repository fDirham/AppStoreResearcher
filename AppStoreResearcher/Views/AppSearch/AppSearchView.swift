//
//  AppSearchView.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/17/24.
//

import SwiftUI
import Combine

struct AppSearchView: View {
    @Environment(ServiceCentral.self) private var serviceCentral
    @Environment(UserSelection.self) private var userSelection
    @Environment(DataManager.self) private var dataManager
    
    @Binding var isPresented: Bool
    @State var vm = ViewModel()
    @FocusState var searchBarFocused: Bool
    
    let frameWidth: CGFloat = 500
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(alignment: .center, spacing: 0) {
                SearchBarView(
                    searchBarFocused: $searchBarFocused,
                    searchVal: $vm.searchVal,
                    isLoading: vm.isSearchLoading,
                    onSearch: vm.doSearch
                )
                
                if !vm.displaySearchResults.isEmpty {
                    Divider()
                        .frame(width: frameWidth - 20)
                    SearchResultsView(searchResults: vm.displaySearchResults, onAdd: vm.onAddSearchResult(searchRes:), isAddLoading: vm.isAddLoading)
                        .padding(.top, 16)
                }
            }
            .roundedBG(fill: Color.macBrown, cornerRadius: 12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.macBrownLight))
            .shadow(radius: 16)
            .frame(width: frameWidth)
            .frame(maxHeight: 300)
        }
        .onAppear {
            vm.setup(
                serviceCentral: serviceCentral,
                userSelection: userSelection,
                dataManager: dataManager,
                onAddFinish: self.handleAddFinish
            )
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {  /// Anything over 0.5 seems to work
                self.searchBarFocused = true
            }
        }
        .alert(
            Text("Error"),
            isPresented: $vm.showErrorAlert
        ) {
            Button("Ok") {
                // Handle the retry action.
                vm.showErrorAlert = false
            }
        } message: {
            Text(vm.errorVal?.localizedDescription ?? "Unknown error")
        }
    }
    
    private func handleAddFinish() {
        isPresented = false
    }
}

extension AppSearchView {
    @Observable
    class ViewModel {
        var serviceCentral: ServiceCentral!
        var dataManager: DataManager!
        var userSelection: UserSelection!
        
        var searchVal: String = ""
        var isSearchLoading: Bool = false
        var itunesSearchResults: [ItunesSearchRes.Result] = []
        var displaySearchResults: [AppSearchRes] {
            itunesSearchResults.map({obj in AppSearchRes(itunesResult: obj)})
        }
        var onAddFinish: (() -> Void)!
        
        var errorVal: Error?
        var showErrorAlert: Bool {
            set {
                errorVal = nil
            }
            get {
                errorVal != nil
            }
        }
        
        var isAddLoading: Bool = false
        
        func setup(
            serviceCentral: ServiceCentral,
            userSelection: UserSelection,
            dataManager: DataManager,
            onAddFinish: @escaping () -> Void
        )
        {
            self.serviceCentral = serviceCentral
            self.userSelection = userSelection
            self.dataManager = dataManager
            self.onAddFinish = onAddFinish
        }
        
        func doSearch() async {
            if searchVal == "" {
                self.itunesSearchResults = []
            }
            else if !isSearchLoading {
                isSearchLoading = true
                
                do {
                    let queryRes = try await serviceCentral.appStoreSearcher.queryItunesSearch(searchQuery: searchVal)
                    
                    if queryRes.autoSelectFirst {
                        let itunesRes = queryRes.result
                        if itunesRes.resultCount > 0 {
                            self.itunesSearchResults = itunesRes.results
                            let toAdd = itunesRes.results.first!
                            let searchRes = AppSearchRes(itunesResult: toAdd)
                            await onAddSearchResult(searchRes: searchRes)
                        }
                    }
                    else {
                        let itunesRes = queryRes.result
                        self.itunesSearchResults = itunesRes.results
                    }
                }
                catch {
                    print(error)
                    errorVal = "Cannot get search results. Check your wifi and try again later." as LocalizedError
                }
                
                isSearchLoading = false
            }
        }
        
        func onAddSearchResult(searchRes: AppSearchRes) async {
            var aspToAdd: AppStorePage!
            
            do {
                
                // Check if other bundle ids in group already exists
                guard let selectedPageGroup = userSelection?.pageGroup else {
                    throw "Please select a group."
                }
                
                if DataManager.doesPageGroupContainAppStorePageWithBundleId(searchRes.bundleId, pageGroup: selectedPageGroup) {
                    throw "You have already added this app to this group."
                }
                
                do {
                    // Check if ASP exists
                    if let existingAsp = try dataManager.getAppStorePageWithBundleId(searchRes.bundleId) {
                        aspToAdd = existingAsp
                    }
                    else {
                        guard let itunesRes = itunesSearchResults.first(where: {obj in
                            obj.bundleId == searchRes.bundleId
                        }) else {
                            throw "Can't find itunesRes for given appSearchRes"
                        }
                        
                        isAddLoading = true
                        let scrapeRes = try await serviceCentral.appStoreSearcher.queryAppStorePage(pageUrl: itunesRes.trackViewUrl!)
                        
                        aspToAdd = dataManager.createAppStorePage(itunesRes: itunesRes, scrapeRes: scrapeRes)
                        isAddLoading = false
                    }
                    
                    dataManager.createNewPageItem(asp: aspToAdd, pageGroup: selectedPageGroup)
                    
                    onAddFinish()
                }
                catch {
                    // All errors here are due to system errors
                    print(error)
                    errorVal = "System error. Please try again later." as LocalizedError
                }
            }
            catch {
                // All errors here alert user
                errorVal = error
            }
            
        }
    }
}

struct AppSearchView_Preview: PreviewProvider {
    struct Container: View {
        @State private var serviceCentral = ServiceCentral.preview
        @State private var userSelection = UserSelection.preview
        @State private var dataManager = DataManager.preview
        
        var body: some View {
            AppSearchView(isPresented: .constant(true))
                .environment(serviceCentral)
                .environment(userSelection)
                .environment(dataManager)
        }
    }
    
    static var previews: some View {
        Container()
    }
}
