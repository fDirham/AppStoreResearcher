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
    @State private var vm: ViewModel = ViewModel()
    
    var pg: PageGroup
    
    init(pg: PageGroup) {
        self.pg = pg
    }
    
    var body: some View {
        Table(of: AppStorePage.self, selection: $vm.selectedAppStorePageId, sortOrder: $vm.sortOrder) {
            TableColumn("App", value: \.app_title.unwrapOrEmpty)
            iconColumn
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


extension IconModeView {
    @Observable class ViewModel: PageGroupTableModel {
    }
}

struct IconModeView_Preview: PreviewProvider {
    struct Container: View {
        var body: some View {
            IconModeView(pg: DataManager.preview.getRandomAppGroup()!)
        }
    }
    
    static var previews: some View {
        Container()
    }
}
