//
//  ContentView.swift
//  Shared
//
//  Created by Kiyan Gauss on 6/22/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ListView(viewModel: ListViewModel())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
