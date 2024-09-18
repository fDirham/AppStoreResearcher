//
//  SearchResultsView.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/18/24.
//

import SwiftUI
import NukeUI

struct SearchResultsView: View {
    var searchResults: [DummySearchRes]
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(searchResults, id: \.appTitle) { res in
                    SearchResultBlockView(searchResult: res)
                }
            }
        }
        .scrollIndicators(.visible)
    }
}

struct SearchResultBlockView: View {
    var searchResult: DummySearchRes
    
    var body: some View {
        HStack(alignment: .center) {
            let urlString = searchResult.appUrl
            LazyImage(url: URL(string: urlString)) { state in
                if let image = state.image {
                    image.resizable().aspectRatio(contentMode: .fill)
                } else if state.error != nil {
                    Color.red // Indicates an error
                } else {
                    Color.gray
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .frame(width: 32, height: 32)
            VStack(alignment: .leading) {
                Text(searchResult.appTitle)
                    .font(.system(size: 14))
                Text(searchResult.subtitle)
                    .font(.system(size: 12))
            }
            Spacer()
            HStack{
                Button(action: {
                    print("TODO")
                }) {
                    Image(systemName: "link")
                }
                .buttonStyle(.borderless)
                Button(action: {
                    print("TODO")
                }) {
                    Image(systemName: "plus.circle")
                }
                .buttonStyle(.borderless)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

struct SearchResultsView_Preview: PreviewProvider {
    struct Container: View {
        @State private var searchResults: [DummySearchRes] = []
        
        var body: some View {
            SearchResultsView(searchResults: searchResults)
                .onAppear {
                    do {
                        if let res: [DummySearchRes] = try decodeJSONFile(fileName: "dummy_search", fileType: "json") {
                            searchResults = res
                        }
                    }
                    catch{}
                }
        }
    }
    
    static var previews: some View {
        Container()
    }
}
