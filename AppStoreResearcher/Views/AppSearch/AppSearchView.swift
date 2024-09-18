//
//  AppSearchView.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/17/24.
//

import SwiftUI
import Combine

struct AppSearchView: View {
    @Binding var isPresented: Bool
    @State var vm = ViewModel()
    @FocusState var searchBarFocused: Bool
        
    let detector = PassthroughSubject<Void, Never>()
    let publisher: AnyPublisher<Void, Never>
    let frameWidth: CGFloat = 500
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        
        publisher = detector
            .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
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
                
                if !vm.searchResults.isEmpty {
                    Divider()
                        .frame(width: frameWidth - 20)
                    SearchResultsView(searchResults: vm.searchResults)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {  /// Anything over 0.5 seems to work
                self.searchBarFocused = true
            }
        }
    }
}

extension AppSearchView {
    @Observable
    class ViewModel {
        var searchVal: String = "some text"
        var isLoading: Bool = false
        var searchResults: [DummySearchRes] = []
        
        func doSearch() {
            Task {
                if searchVal != "" && !isLoading {
                    // TODO: Replace with actual implementation
                    isLoading = true
                    try? await Task.sleep(for: .seconds(1))
                    isLoading = false
                    
                    do {
                        if let results: [DummySearchRes] = try decodeJSONFile(fileName: "dummy_search", fileType: "json") {
                            self.searchResults = results
                        }
                    }
                    catch {
                        print("Cannot get dummy results")
                    }
                }
            }
        }
    }
}

#Preview {
    AppSearchView(isPresented: .constant(true))
}
