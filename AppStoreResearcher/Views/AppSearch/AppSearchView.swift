//
//  AppSearchView.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/17/24.
//

import SwiftUI
import Combine

struct AppSearchView: View {
    @Binding var isPresented: Bool
    @State var vm = ViewModel()
    @FocusState var fieldFocused: Bool
        
    let detector = PassthroughSubject<Void, Never>()
    let publisher: AnyPublisher<Void, Never>
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        
        publisher = detector
            .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    init(isPresented: Binding<Bool>, vm: ViewModel) {
        self.init(isPresented: isPresented)
        self.vm = vm
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 16, height: 16)
                TextField("Search...", text: $vm.searchVal)
                    .focused($fieldFocused)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(.primary)
                    .padding(12)
                    .font(.system(size: 18))
                    .background(.clear)
                    .onSubmit {
                        vm.onSearch()
                    }
                    .onChange(of: vm.searchVal) { detector.send() }
                    .onReceive(publisher) { vm.onSearch() }
            }
            .padding(.horizontal)
            .roundedBG(fill: Color.macBrown, cornerRadius: 12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.macBrownLight))
            .frame(width: 500)
            .shadow(radius: 16)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {  /// Anything over 0.5 seems to work
                self.fieldFocused = true
            }
        }
    }
}

extension AppSearchView {
    @Observable
    class ViewModel {
        var searchVal: String = ""
        
        func onSearch(){
            if searchVal != "" {
                print("Searching", searchVal)
            }
        }
        
    }
}

#Preview {
    AppSearchView(isPresented: .constant(true))
}
