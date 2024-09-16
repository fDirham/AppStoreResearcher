//
//  ScreenshotModeView.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/12/24.
//

import SwiftUI
import NukeUI

@MainActor
struct ScreenshotModeView: View {
    @State private var vm: ViewModel = ViewModel()
    
    var pg: PageGroup
    
    init(pg: PageGroup) {
        self.pg = pg
    }
    
    var body: some View {
        Table(of: AppStorePage.self, selection: $vm.selectedAppStorePageId, sortOrder: $vm.sortOrder) {
            TableColumn("App", value: \.app_title.unwrapOrEmpty)
            screenshotColumns
        } rows: {
            ForEach(vm.aspList, id: \.app_bundle_id) { obj in
                TableRow(obj)
            }
        }
        .onAppear {
            vm.setPageGroup(pg: pg)
        }
        .onChange(of: pg) {
            vm.setPageGroup(pg: pg)
        }
    }
    
    @TableColumnBuilder<AppStorePage, Never>
    var screenshotColumns: some TableColumnContent<AppStorePage, Never> {
        screenshotColumn(index: 0)
        screenshotColumn(index: 1)
        screenshotColumn(index: 2)
        screenshotColumn(index: 3)
        screenshotColumn(index: 4)
        screenshotColumn(index: 5)
        screenshotColumn(index: 6)
        screenshotColumn(index: 7)
        screenshotColumn(index: 8)
        screenshotColumn(index: 9)
    }
    
    @TableColumnBuilder<AppStorePage, Never>
    func screenshotColumn(index: Int) -> some TableColumnContent<AppStorePage, Never> {
        TableColumn("\(index)") {model in
            renderScreenshot(model, index: index)
        }
        .width(200)
    }
    
    
    @ViewBuilder
    private func renderScreenshot(_ asp: AppStorePage, index screenshotIdx: Int) -> some View {
        let screenshotShList: [StringHolder] = asp.screenshot_ios?.array as? [StringHolder] ?? []
        let screenshotList = screenshotShList.map{sh in sh.string ?? ""}
        if screenshotList.count >= screenshotIdx + 1 {
            LazyImage(url: URL(string: screenshotList[screenshotIdx])){ state in
                if let image = state.image {
                    image.resizable().aspectRatio(contentMode: .fit)
                } else if state.error != nil {
                    Color.red
                } else {
                    Color.gray
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .frame(width: 200, height: 350)
        }
    }
}


extension ScreenshotModeView {
    @Observable class ViewModel {
        var pg: PageGroup? = nil
        var piList: [PageItem] = []
        var aspList: [AppStorePage] = []
        
        var selectedAppStorePageId: AppStorePage.ID? = nil
        var selectedPageItem: PageItem? {
            if selectedAppStorePageId == nil {
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
        
        func setPageGroup(pg: PageGroup) {
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
        
        private func _onSortChange(newSortOder: [KeyPathComparator<AppStorePage>]){
            if let newKey = newSortOder.first {
                aspList.sort(using: newKey)
            }
        }
    }
}

struct ScreenshotModeView_Preview: PreviewProvider {
    struct Container: View {
        var body: some View {
            ScreenshotModeView(pg: DataManager.preview.getRandomAppGroup()!)
        }
    }
    
    static var previews: some View {
        Container()
    }
}
