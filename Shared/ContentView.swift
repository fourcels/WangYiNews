//
//  ContentView.swift
//  Shared
//
//  Created by Kiyan Gauss on 6/22/21.
//

import SwiftUI

struct ContentView: View {
    
    var main: some View {
        ListView(viewModel: ListViewModel())
            .navigationTitle("今日热点")
    }
    
    var body: some View {
        NavigationView {
            #if os(macOS)
            main
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button(action: {
                            NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                        }) {
                            Image(systemName: "sidebar.left")
                        }
                        .keyboardShortcut("S", modifiers: .command)
                    }
                }
                .listStyle(SidebarListStyle())
                .frame(minWidth: 300, minHeight: 600)
            #else
            main
            #endif
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
