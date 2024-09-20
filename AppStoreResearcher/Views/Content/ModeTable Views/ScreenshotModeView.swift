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
    var body: some View {
        ModeTableViewWrapper(tableColumns: allTableColumns)
    }
    
    @TableColumnBuilder<AppStorePage, KeyPathComparator<AppStorePage>>
    var allTableColumns: some TableColumnContent<AppStorePage, KeyPathComparator<AppStorePage>> {
        TableColumn("App", value: \.app_title.unwrapOrEmpty)
        screenshotColumns
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

struct ScreenshotModeView_Preview: PreviewProvider {
    struct Container: View {
        @State private var userSelection =  UserSelection.preview
        @State private var dataManager = DataManager.preview

        var body: some View {
            ScreenshotModeView()
                .environment(userSelection)
                .environment(dataManager)
        }
    }
    
    static var previews: some View {
        Container()
    }
}
