//
//  MasterNoteView.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/12/24.
//

import SwiftUI

struct MasterNoteView: View {
    @Environment(UserSelection.self) private var userSelection

    var body: some View {
        VStack{
            Text("Note view")
            Text("Chosen")
            Text(userSelection.pageItem?.app_store_page?.app_title ?? "None")
        }
        .frame(width: 300)
    }
}

struct MasterNoteView_Preview: PreviewProvider {
    struct Container: View {
        @State private var userSelection = UserSelection()
        
        var body: some View {
            MasterNoteView()
                .environment(userSelection)
        }
    }
    
    static var previews: some View {
        Container()
    }
}
