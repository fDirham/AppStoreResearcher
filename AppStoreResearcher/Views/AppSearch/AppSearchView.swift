//
//  AppSearchView.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/17/24.
//

import SwiftUI
import Combine

struct AppSearchView: View {
    @Environment(UserSelection.self) private var userSelection
    @Binding var isPresented: Bool
    @State var vm = ViewModel()
    @FocusState var searchBarFocused: Bool
        
    let detector = PassthroughSubject<Void, Never>()
    let publisher: AnyPublisher<Void, Never>
    let frameWidth: CGFloat = 500
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        
        publisher = detector
            .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    init(isPresented: Binding<Bool>, vm: ViewModel) {
        self.init(isPresented: isPresented)
        self.vm = vm
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
                    isLoading: vm.isLoading,
                    onSearch: vm.doSearch
                )
                
                if !vm.displaySearchResults.isEmpty {
                    Divider()
                        .frame(width: frameWidth - 20)
                    SearchResultsView(searchResults: vm.displaySearchResults, onAdd: vm.onAddSearchResult(searchRes:))
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
            vm.setup(userSelection: userSelection)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {  /// Anything over 0.5 seems to work
                self.searchBarFocused = true
            }
        }
    }
}

extension AppSearchView {
    @Observable
    class ViewModel {
        var appStoreSearcher: AppStoreSearcherService
        var dataManager: DataManager
        var userSelection: UserSelection?

        var searchVal: String = ""
        var isLoading: Bool = false
        var itunesSearchResults: [ItunesSearchRes.Result] = []
        var displaySearchResults: [AppSearchRes] {
            itunesSearchResults.map({obj in AppSearchRes(itunesResult: obj)})
        }
        
        init(dataManager: DataManager = DataManager.shared, appStoreSearcher: AppStoreSearcherService = MainAppStoreSearcherService.shared) {
            // TODO: Change back when done testing
            self.appStoreSearcher = DummyAppStoreSearcherService()
            self.dataManager = dataManager
        }
        
        func setup(userSelection: UserSelection){
            self.userSelection = userSelection
        }
        
        func doSearch() {
            Task {
                if searchVal == "" {
                    self.itunesSearchResults = []
                }
                else if !isLoading {
                    isLoading = true
                    
                    do {
                        let itunesRes = try await appStoreSearcher.queryItunesSearch(searchQuery: searchVal)
                        
                        self.itunesSearchResults = itunesRes.results
                    }
                    catch {
                        // TODO: Better error handling
                        print("Cannot get search results", error.localizedDescription)
                    }
                    
                    isLoading = false
                }
            }
        }
        
        func onAddSearchResult(searchRes: AppSearchRes) {
            var aspToAdd: AppStorePage!

            do {
                
                // Check if other bundle ids in group already exists
                guard let selectedPageGroup = userSelection?.pageGroup else {
                    throw "Please select a group. This error should not be possible."
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
                        aspToAdd = dataManager.createIncompleteAppStorePage(itunesRes: itunesRes)
                        
                        // TODO: Add background task to complete asp
                    }
                    
                    dataManager.createNewPageItem(asp: aspToAdd, pageGroup: selectedPageGroup)
                    
                    // TODO: Refresh
                }
                catch {
                    // All errors here are due to system errors
                    print(error.localizedDescription)
                }
            }
            catch {
                // All errors here alert user
                // TODO: Alert user
                print(error.localizedDescription)
            }
            
        }
    }
}

struct AppSearchView_Preview: PreviewProvider {
    struct Container: View {
        @State private var userSelection: UserSelection
        
        init(){
            userSelection = UserSelection()
            userSelection.pageGroup = DataManager.preview.getRandomAppGroup()
            userSelection.pageItem = DataManager.preview.getRandomPageItem(pageGroup: userSelection.pageGroup!)
        }
        
        var body: some View {
            AppSearchView(isPresented: .constant(true), vm: AppSearchView.ViewModel(
                dataManager: DataManager.preview,
                appStoreSearcher: DummyAppStoreSearcherService())
            )
            .environment(userSelection)
        }
    }
    
    static var previews: some View {
        Container()
    }
}
