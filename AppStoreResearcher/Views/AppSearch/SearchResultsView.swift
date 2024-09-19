//
//  SearchResultsView.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/18/24.
//

import SwiftUI
import NukeUI

struct SearchResultsView: View {
    var searchResults: [AppSearchRes]
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(searchResults, id: \.appUrl) { res in
                    SearchResultBlockView(searchResult: res)
                }
            }
        }
        .scrollIndicators(.visible)
    }
}

struct SearchResultBlockView: View {
    var searchResult: AppSearchRes
    
    var body: some View {
        HStack(alignment: .center) {
            let urlString = searchResult.appIcon
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
            Text(searchResult.appTitle)
                .font(.system(size: 14))
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
        @State private var searchResults: [AppSearchRes] = AppSearchRes.DUMMY
        
        var body: some View {
            SearchResultsView(searchResults: searchResults)
        }
    }
    
    static var previews: some View {
        Container()
    }
}
