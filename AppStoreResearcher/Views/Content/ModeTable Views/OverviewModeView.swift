//
//  OverviewModeView.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/12/24.
//

import SwiftUI
import NukeUI

@MainActor
struct OverviewModeView: View {
    var pg: PageGroup

    init(pg: PageGroup) {
        self.pg = pg
    }
    
    var body: some View {
        ModeTableViewWrapper(pg: self.pg, tableColumns: allTableColumns)
    }
    
    @TableColumnBuilder<AppStorePage, KeyPathComparator<AppStorePage>>
    var allTableColumns: some TableColumnContent<AppStorePage, KeyPathComparator<AppStorePage>> {
        tableColumns1
        tableColumns2
    }
    
    @TableColumnBuilder<AppStorePage, KeyPathComparator<AppStorePage>>
    var tableColumns1: some TableColumnContent<AppStorePage, KeyPathComparator<AppStorePage>> {
        TableColumn("Icon") {model in
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
        TableColumn("Subtitle", value: \.app_subtitle.unwrapOrEmpty)
        TableColumn("Description", value: \.app_description.unwrapOrEmpty)
        TableColumn("Creator", value: \.creator_name.unwrapOrEmpty)
        TableColumn("Rating avg", value: \.rating_avg) {model in
            let valStr = String(format: "%.2f", model.rating_avg)
            let val = CGFloat(model.rating_avg)
            HStack{
                Text("\(valStr)")
                RatingView(rating: val, maxRating: 5)
            }
        }
        TableColumn("Rating count", value: \.rating_count) {model in
            Text("\(model.rating_count)")
        }
        TableColumn("Current version", value: \.current_version.unwrapOrEmpty) {model in
            Text("\(model.current_version ?? "")")
        }
        TableColumn("Release date", sortUsing: KeyPathComparator(\AppStorePage.release_date, comparator: OptionalDateComparator())) {model in
            Text(model.release_date!, format: .dateTime.day().month().year())
        }
        TableColumn("Last updated", sortUsing: KeyPathComparator(\AppStorePage.current_version_release_date, comparator: OptionalDateComparator())) {model in
            Text(model.current_version_release_date!, format: .dateTime.day().month().year())
        }
    }
    
    @TableColumnBuilder<AppStorePage, KeyPathComparator<AppStorePage>>
    var tableColumns2: some TableColumnContent<AppStorePage, KeyPathComparator<AppStorePage>> {
        TableColumn("Genre", value: \.primary_genre!)
        TableColumn("Price", value: \.purchase_price) {model in
            let priceStr = model.purchase_price == 0 ? "Free" : "\(model.purchase_price) \(model.purchase_currency ?? "")"
            Text(priceStr)
        }
        TableColumn("In app purchases", sortUsing: KeyPathComparator(\AppStorePage.in_app_purchases, comparator: OptionalOrderedSetCountComparator())) {model in
            let valStr = model.in_app_purchases?.count ?? 0 > 0 ? "Yes" : "No"
            Text(valStr)
        }
        TableColumn("iOS screenshots", sortUsing: KeyPathComparator(\AppStorePage.screenshot_ios, comparator: OptionalOrderedSetCountComparator())) {model in
            let val = model.screenshot_ios?.count ?? 0
            Text("\(val)")
        }
        
        TableColumn("iPad screenshots", sortUsing: KeyPathComparator(\AppStorePage.screenshot_ipad, comparator: OptionalOrderedSetCountComparator())) {model in
            let val = model.screenshot_ipad?.count ?? 0
            Text("\(val)")
        }
    }
}

struct OverviewModeView_Preview: PreviewProvider {
    struct Container: View {
        @State private var userSelection = UserSelection()
        
        var body: some View {
            OverviewModeView(pg: DataManager.preview.getRandomAppGroup()!)
                .environment(userSelection)
        }
    }
    
    static var previews: some View {
        Container()
    }
}

