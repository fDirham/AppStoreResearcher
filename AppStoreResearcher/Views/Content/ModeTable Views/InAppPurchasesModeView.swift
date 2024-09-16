//
//  InAppPurchasesModeView.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/16/24.
//

import SwiftUI
import NukeUI

@MainActor
struct InAppPurchasesModeView: View {
    var pg: PageGroup
    
    init(pg: PageGroup) {
        self.pg = pg
    }
    
    var body: some View {
        ModeTableViewWrapper(pg: pg, tableColumns: allTableColumns)
    }
    
    @TableColumnBuilder<AppStorePage, KeyPathComparator<AppStorePage>>
    var allTableColumns: some TableColumnContent<AppStorePage, KeyPathComparator<AppStorePage>> {
        TableColumn("") {model in
            let urlString = model.app_icon_60!
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
        }
        .width(32)
        TableColumn("App", value: \.app_title.unwrapOrEmpty)
        TableColumn("List") {model in
            renderAppList(asp: model)
        }
        .width(340)
    }
    
    @ViewBuilder
    private func renderAppList(asp: AppStorePage) -> some View {
        let inAppPurchasesList = asp.in_app_purchases?.array as? [InAppPurchaseSpec] ?? []
    
        VStack(alignment: .leading, spacing: 8){
            ForEach(inAppPurchasesList, id: \.desc) {iap in
                HStack {
                    Text(iap.desc!)
                    Spacer()
                    Text(iap.price_str!)
                }
            }
        }
        .padding(.vertical, 12)
    }
}

struct InAppPurchasesModeView_Preview: PreviewProvider {
    struct Container: View {
        var body: some View {
            InAppPurchasesModeView(pg: DataManager.preview.getRandomAppGroup()!)
        }
    }
    
    static var previews: some View {
        Container()
    }
}
