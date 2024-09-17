//
//  IconModeView.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/12/24.
//

import SwiftUI
import NukeUI

@MainActor
struct IconModeView: View {
    var pg: PageGroup
    
    init(pg: PageGroup) {
        self.pg = pg
    }
    
    var body: some View {
        ModeTableViewWrapper(pg: pg, tableColumns: allTableColumns)
    }
    
    @TableColumnBuilder<AppStorePage, KeyPathComparator<AppStorePage>>
    var allTableColumns: some TableColumnContent<AppStorePage, KeyPathComparator<AppStorePage>> {
        TableColumn("App", value: \.app_title.unwrapOrEmpty)
        iconColumn
    }

    @TableColumnBuilder<AppStorePage, Never>
    var iconColumn: some TableColumnContent<AppStorePage, Never> {
        TableColumn("Icon") {model in
            let iconUrl: String = model.app_icon_512!
            LazyImage(url: URL(string: iconUrl)){ state in
                if let image = state.image {
                    image.resizable().aspectRatio(contentMode: .fit)
                } else if state.error != nil {
                    Color.red
                } else {
                    Color.gray
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .frame(width: 206, height: 206)
        }
    }
}

struct IconModeView_Preview: PreviewProvider {
    struct Container: View {
        @State private var userSelection = UserSelection()
        
        var body: some View {
            IconModeView(pg: DataManager.preview.getRandomAppGroup()!)
                .environment(userSelection)
        }
    }
    
    static var previews: some View {
        Container()
    }
}
