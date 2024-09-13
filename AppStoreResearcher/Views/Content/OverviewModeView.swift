//
//  OverviewModeView.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/12/24.
//

import SwiftUI

struct OverviewModeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var vm: ViewModel
    
    init(pg: PageGroup) {
        vm = ViewModel(pg: pg)
    }
    
    @TableColumnBuilder<AppStorePage, KeyPathComparator<AppStorePage>>
    var tableColumns1: some TableColumnContent<AppStorePage, KeyPathComparator<AppStorePage>> {
        TableColumn("Icon") {model in
            let urlString = model.app_icon_60!
            AsyncImage(url: URL(string: urlString)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Color.gray.opacity(1)
            }
            .frame(width: 32, height: 32)
            .cornerRadius(6)
        }
        .width(32)
        TableColumn("App", value: \.app_title.unwrapOrEmpty)
        TableColumn("Subtitle", value: \.app_subtitle.unwrapOrEmpty)
        TableColumn("Description", value: \.app_description.unwrapOrEmpty)
        TableColumn("Creator", value: \.creator_name.unwrapOrEmpty)
        TableColumn("Rating avg", value: \.rating_avg) {model in
            Text("\(model.rating_avg)")
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

    var body: some View {
        Table(of: AppStorePage.self, selection: $vm.selectedAppStorePageId, sortOrder: $vm.sortOrder) {
            tableColumns1
            tableColumns2
        } rows: {
            ForEach(vm.aspList) { obj in
                TableRow(obj)
            }
        }
        .onAppear {
            vm.setup(vc: viewContext)
        }
    }
}

extension OverviewModeView {
    @Observable class ViewModel {
        let pg: PageGroup
        var vc: NSManagedObjectContext?
        
        var piList: [PageItem] = []
        var aspList: [AppStorePage] = []
        
        var selectedAppStorePageId: AppStorePage.ID? = nil
        var selectedPageItem: PageItem? {
            if vc == nil || selectedAppStorePageId == nil || aspList.isEmpty {
                return nil
            }
            
            let filtered = piList.filter({($0.app_store_page)?.id == selectedAppStorePageId}) as [PageItem]
            if filtered.isEmpty {
                return nil
            }
            return filtered.first
        }
        var selectedAppStorePage: AppStorePage? {
            if selectedPageItem == nil {
                return nil
            }
           
            return selectedPageItem?.app_store_page
        }
        private var _sortOrder: [KeyPathComparator<AppStorePage>] = []
        var sortOrder: [KeyPathComparator<AppStorePage>] {
            set {
                _onSortChange(newSortOder: newValue)
                _sortOrder = newValue
            }
            get { return _sortOrder}
          }

        init(pg: PageGroup) {
            self.pg = pg
            if let newPiList = pg.page_items {
                let piListArr: [PageItem] = newPiList.array as? [PageItem] ?? []
                piList = piListArr
            }
            else {
                piList = []
            }
            
            aspList = piList.map{$0.app_store_page!}
        }
        
        func setup(vc: NSManagedObjectContext) {
            self.vc = vc
        }
        
        private func _onSortChange(newSortOder: [KeyPathComparator<AppStorePage>]){
            if let newKey = newSortOder.first {
                aspList.sort(using: newKey)
            }
        }
    }
}

struct OverviewModeView_Preview: PreviewProvider {
    struct Container: View {
        let vc: NSManagedObjectContext
        let pg: PageGroup
        
        init(){
            vc = PersistenceController.preview.container.viewContext
            pg = PersistenceController.preview.getRandomAppGroup()!
        }
        
        
        var body: some View {
            OverviewModeView(pg: pg)
                .environment(\.managedObjectContext, vc)
        }
    }
    
    static var previews: some View {
        Container()
    }
}

