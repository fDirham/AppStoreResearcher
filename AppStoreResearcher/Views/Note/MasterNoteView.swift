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
    @Environment(DataManager.self) private var dataManager
    
    @State var vm = ViewModel()
    
    let detector = PassthroughSubject<Void, Never>()
    let publisher: AnyPublisher<Void, Never>
    
    init() {
        publisher = detector
            .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    init(vm: ViewModel) {
        self.init()
        self.vm = vm
    }
    
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                Text("Notes")
                    .font(.title)
                Picker("Note Mode", selection: $vm.noteMode) {
                    Text(NoteMode.NONE.rawValue).tag(NoteMode.NONE)
                    if vm.currPageGroup != nil {
                        Text(NoteMode.PAGE_GROUP.rawValue).tag(NoteMode.PAGE_GROUP)
                    }
                    if vm.currPageItem != nil {
                        Text(NoteMode.PAGE_ITEM.rawValue).tag(NoteMode.PAGE_ITEM)
                    }
                }
                .labelsHidden()
                if vm.noteMode == .PAGE_ITEM {
                    Text(userSelection.pageItem?.app_store_page?.app_title ?? "No app selected")
                        .fontWeight(.semibold)
                }
            }
            .padding()
            if vm.noteMode != .NONE {
                ZStack {
                    TextEditor(text: $vm.noteContents)
                        .padding(.vertical)
                        .padding(.leading)
                }
                .scrollContentBackground(.hidden)
                .background(Color.gray.opacity(0.1))
                .onChange(of: vm.noteContents) { detector.send() }
                .onReceive(publisher) { vm.saveCurrentNote() }
            }
            Spacer()
        }
        .frame(width: 300)
        .onAppear() {
            vm.setup(userSelection: userSelection, dataManager: dataManager)
        }
        .onChange(of: userSelection.pageGroup) {
            vm.changePageGroup()
        }
        .onChange(of: userSelection.pageItem) {
            vm.changePageItem()
        }
    }
}

extension MasterNoteView {
    @Observable
    class ViewModel {
        var dataManager: DataManager!
        var userSelection: UserSelection!
        
        private var _noteMode: NoteMode = .NONE
        var noteMode: NoteMode {
            set {
                onNoteModeChange(newMode: newValue)
                _noteMode = newValue
            }
            get {
                return _noteMode
            }
        }
        
        private var _currPageGroup: PageGroup?
        var currPageGroup: PageGroup? {
            set {
                onCurrPageGroupChange(oldPg: _currPageGroup, newPg: newValue)
                _currPageGroup = newValue
            }
            get {
                return _currPageGroup
            }
        }
        private var _currPageItem: PageItem?
        var currPageItem: PageItem? {
            set {
                onCurrPageItemChange(oldPi: _currPageItem, newPi: newValue)
                _currPageItem = newValue
            }
            get {
                return _currPageItem
            }
        }
        
        var noteContents: String = ""
        
        func setup(userSelection: UserSelection, dataManager: DataManager){
            self.userSelection = userSelection
            self.dataManager = dataManager

            var startWithPg = false
            var startWithPi = false
            
            if let pg = userSelection.pageGroup {
                startWithPg = true
                currPageGroup = pg
            }
            if let pi = userSelection.pageItem {
                startWithPi = true
                currPageItem = pi
            }
            
            if startWithPi {
                self.noteMode = .PAGE_ITEM
            }
            else if startWithPg {
                self.noteMode = .PAGE_GROUP
            }
        }
        
        func saveCurrentNote(){
            if self.noteMode == .PAGE_GROUP {
                if let pg = currPageGroup {
                    saveVMNoteToPageGroupCD(pageGroup: pg)
                    dataManager.saveData()
                }
            }
            else if self.noteMode == .PAGE_ITEM {
                if let pi = currPageItem {
                    saveVMNoteToPageItemCD(pageItem: pi)
                    dataManager.saveData()
                }
            }
        }
        
        // Triggered by view to let us know the user has changed these values
        func changePageGroup(){
            self.currPageGroup = userSelection!.pageGroup
            
            if self.currPageGroup != nil {
                if self.noteMode != .PAGE_GROUP {
                    self.noteMode = .PAGE_GROUP
                }
            }
        }
        
        func changePageItem(){
            self.currPageItem = userSelection!.pageItem
            
            if self.currPageItem != nil {
                if self.noteMode != .PAGE_ITEM {
                    self.noteMode = .PAGE_ITEM
                }
            }
        }
        
        // MARK: On values change
        private func onNoteModeChange(newMode: NoteMode){
            self.saveCurrentNote()
            
            if newMode == .NONE {
                self.noteContents = ""
            }
            else if newMode == .PAGE_GROUP {
                if let pg = currPageGroup {
                    loadPageGroupNoteFromCD(pageGroup: pg)
                }
            }
            else if newMode == .PAGE_ITEM {
                if let pi = currPageItem {
                    loadPageItemNoteFromCD(pageItem: pi)
                }
            }
        }
        
        private func onCurrPageGroupChange(oldPg: PageGroup?, newPg: PageGroup?){
            if self.noteMode == .PAGE_GROUP {
                // Save old page group
                if let oldPg = oldPg {
                    saveVMNoteToPageGroupCD(pageGroup: oldPg)
                }
                
                // Change note contents
                if let newPg = newPg {
                    loadPageGroupNoteFromCD(pageGroup: newPg)
                }
            }
        }
        
        private func onCurrPageItemChange(oldPi: PageItem?, newPi: PageItem?) {
            if self.noteMode == .PAGE_ITEM {
                // Save old page group
                if let oldPi = oldPi {
                    saveVMNoteToPageItemCD(pageItem: oldPi)
                }
                
                // Change note contents
                if let newPi = newPi {
                    loadPageItemNoteFromCD(pageItem: newPi)
                }
            }
        }
        
        // MARK: VM - CD
        private func loadPageGroupNoteFromCD(pageGroup: PageGroup){
            if let groupNote: Note = pageGroup.group_note {
                self.noteContents = groupNote.content ?? ""
            }
            else {
                self.noteContents = ""
                dataManager.createNoteForPageGroup(pageGroup: pageGroup)
            }
        }
        
        private func loadPageItemNoteFromCD(pageItem: PageItem){
            if let itemNote: Note = pageItem.item_note {
                self.noteContents = itemNote.content ?? ""
            }
            else {
                self.noteContents = ""
                dataManager.createNoteForPageItem(pageItem: pageItem)
            }
        }
        
        private func saveVMNoteToPageItemCD(pageItem: PageItem){
            pageItem.item_note!.content = self.noteContents
        }
        
        private func saveVMNoteToPageGroupCD(pageGroup: PageGroup){
            pageGroup.group_note!.content = self.noteContents
        }
    }
}

struct MasterNoteView_Preview: PreviewProvider {
    struct Container: View {
        @State private var userSelection = UserSelection.preview
        @State private var dataManager = DataManager.preview

        var body: some View {
            MasterNoteView()
                .environment(userSelection)
                .environment(dataManager)
        }
    }
    
    static var previews: some View {
        Container()
    }
}
