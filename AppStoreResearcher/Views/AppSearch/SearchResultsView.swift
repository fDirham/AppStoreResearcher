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
    var onAdd: (AppSearchRes) async -> Void
    var isAddLoading: Bool

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(searchResults, id: \.appUrl) { res in
                    SearchResultBlockView(searchResult: res, onAdd: onAdd, isAddLoading: isAddLoading)
                }
            }
        }
        .scrollIndicators(.visible)
    }
}

struct SearchResultBlockView: View {
    var searchResult: AppSearchRes
    var onAdd: (AppSearchRes) async -> Void
    var isAddLoading: Bool

    
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
                Link(destination: URL(string: searchResult.appUrl)!) {
                    Image(systemName: "link")
                }
                if !isAddLoading {
                    Button(action: {
                        Task {
                            await onAdd(searchResult)
                        }
                    }) {
                        Image(systemName: "plus.circle")
                    }
                    .buttonStyle(.borderless)
                    .frame(width: 24, height: 16)
                }
                else {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(0.4)
                        .frame(width: 24, height: 16)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

struct SearchResultsView_Preview: PreviewProvider {
    struct Container: View {
        var body: some View {
            SearchResultsView(searchResults: AppSearchRes.DUMMY, onAdd: {_ in}, isAddLoading: false)
        }
    }
    
    static var previews: some View {
        Container()
    }
}
