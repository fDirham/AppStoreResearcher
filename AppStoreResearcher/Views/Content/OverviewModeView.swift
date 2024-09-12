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
    
    @TableColumnBuilder<AppStorePage, Never>
    var tableColumns1: some TableColumnContent<AppStorePage, Never> {
        TableColumn("Icon") {model in
            let urlString = model.app_icon_60!
            AsyncImage(url: URL(string: urlString)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Color.gray.opacity(0.5)
            }
            .frame(width: 32, height: 32)
            .cornerRadius(6)
        }
        .width(32)
        TableColumn("App", value: \.app_title!)
        TableColumn("Subtitle", value: \.app_subtitle!)
        TableColumn("Description", value: \.app_description!)
        TableColumn("Creator", value: \.creator_name!)
        TableColumn("Rating avg") {model in
            Text("\(model.rating_avg)")
        }
        TableColumn("Rating count") {model in
            Text("\(model.rating_count)")
        }
        TableColumn("Current version") {model in
            Text("\(model.current_version ?? "")")
        }
        TableColumn("Release date") {model in
            Text(model.release_date!, format: .dateTime.day().month().year())
        }
        TableColumn("Last updated") {model in
            Text(model.current_version_release_date!, format: .dateTime.day().month().year())
        }
    }
    
    @TableColumnBuilder<AppStorePage, Never>
    var tableColumns2: some TableColumnContent<AppStorePage, Never> {
        TableColumn("Genre") {model in
            Text(model.current_version_release_date!, format: .dateTime.day().month().year())
        }
        TableColumn("Price") {model in
            let priceStr = model.purchase_price == 0 ? "Free" : "\(model.purchase_price) \(model.purchase_currency ?? "")"
            Text(priceStr)
        }
        TableColumn("In app purchases") {model in
            let valStr = model.in_app_purchases?.count ?? 0 > 0 ? "Yes" : "No"
            Text(valStr)
        }
        TableColumn("iOS screenshots") {model in
            let val = model.screenshot_ios?.count ?? 0
            Text("\(val)")
        }

        TableColumn("iPad screenshots") {model in
            let val = model.screenshot_ipad?.count ?? 0
            Text("\(val)")
        }
    }

    var body: some View {
        Table(of: AppStorePage.self, selection: $vm.selectedAppStorePageId) {
            tableColumns1
            tableColumns2
        } rows: {
            ForEach(vm.aspList) { obj in
                TableRow(obj)
            }
        }
        .onChange(of: vm.selectedPageItem) {
            print("selected", vm.selectedPageItem?.app_store_page?.app_title ?? "")
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
        
        
        var piList: [PageItem] {
            guard let piList = pg.page_items else {
                return []
            }
            let piListArr: [PageItem] = piList.array as? [PageItem] ?? []
            return piListArr
        }
        var aspList: [AppStorePage] {
            return piList.map {$0.app_store_page!}
        }
        
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

        init(pg: PageGroup) {
            self.pg = pg
        }
        
        func setup(vc: NSManagedObjectContext) {
            self.vc = vc
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

