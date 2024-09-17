//
//  MasterNoteView.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/12/24.
//

import SwiftUI
import Combine

struct MasterNoteView: View {
    @Environment(UserSelection.self) private var userSelection
    @State var vm = ViewModel()
    
    let detector = PassthroughSubject<Void, Never>()
    let publisher: AnyPublisher<Void, Never>
    
    init() {
        publisher = detector
            .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                Text("Notes")
                    .font(.title)
                Picker("Note Mode", selection: $vm.noteMode) {
                    Text(NoteMode.PAGE_GROUP.rawValue).tag(NoteMode.PAGE_GROUP)
                    Text(NoteMode.PAGE_ITEM.rawValue).tag(NoteMode.PAGE_ITEM)
                }
                Text(userSelection.pageItem?.app_store_page?.app_title ?? "No app selected")
            }
            .padding()
            TextEditor(text: $vm.noteContents)
                .onChange(of: vm.noteContents) { detector.send() }
                .onReceive(publisher) { vm.saveNoteContents() }
            Spacer()
        }
        .frame(width: 300)
        .onAppear() {
            vm.setup(userSelection: userSelection)
        }
        .onChange(of: userSelection.pageItem) {
            // TODO: The same for page group
            vm.onPageItemChange()
        }
    }
}

extension MasterNoteView {
    @Observable
    class ViewModel {
        var userSelection: UserSelection?
        var noteMode: NoteMode = .PAGE_GROUP // TODO: Actually do stuff here
        var noteContents: String = ""
        
        func setup(userSelection: UserSelection){
            self.userSelection = userSelection
            syncCdToVm()
        }
        
        func saveNoteContents(){
            print("Saving")
            syncVmToCd()
        }
        
        func onPageItemChange(){
            syncCdToVm()
        }

        private func syncVmToCd(){
            // TODO: Handle case for groups and no notes
            guard let selectedPageItem = userSelection?.pageItem else {return }
            guard let note = selectedPageItem.item_note else { return }
            note.content = self.noteContents
        }
        
        private func syncCdToVm(){
            // TODO: Handle case for groups and no notes
            guard let selectedPageItem = userSelection?.pageItem else {return }
            if let note = selectedPageItem.item_note {
                self.noteContents = note.content ?? ""
            }
            else {
                self.noteContents = ""
            }
        }
        
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
