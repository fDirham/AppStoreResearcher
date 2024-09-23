//
//  SearchBarView.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/18/24.
//

import SwiftUI
import Combine

struct SearchBarView: View {
    @FocusState.Binding var searchBarFocused: Bool
    @Binding var searchVal: String
    var onSearch: () async -> Void
    var isLoading: Bool
    
    let detector = PassthroughSubject<Void, Never>()
    let publisher: AnyPublisher<Void, Never>
    
    init(searchBarFocused: FocusState<Bool>.Binding, searchVal: Binding<String>, isLoading: Bool, onSearch: @escaping () async -> Void) {
        self._searchBarFocused = searchBarFocused
        self._searchVal = searchVal
        self.isLoading = isLoading
        self.onSearch = onSearch

        publisher = detector
            .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()

    }
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 16, height: 16)
            TextField("Search...", text: $searchVal)
                .focused($searchBarFocused)
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(.primary)
                .padding(12)
                .font(.system(size: 18))
                .background(.clear)
                .onSubmit {
                    Task {
                       await onSearch()
                    }
                }
                .onChange(of: searchVal) { detector.send() }
                .onReceive(publisher) {
                    Task {
                        await onSearch()
                    }
                }
            HStack{
                Spacer()
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(0.6)
                }
            }
            .frame(width: 60)
        }
        .padding(.horizontal)
    }
}

struct SearchBarView_Preview: PreviewProvider {
    struct Container: View {
        @State private var searchVal: String = ""
        @FocusState private var searchBarFocused: Bool

        var body: some View {
            SearchBarView(searchBarFocused: $searchBarFocused, searchVal: $searchVal, isLoading: false, onSearch: {})
        }
    }
    
    static var previews: some View {
        Container()
    }
}
