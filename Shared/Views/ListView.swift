//
//  ListView.swift
//  WangYiNews
//
//  Created by Kiyan Gauss on 6/22/21.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var viewModel: ListViewModel
    var body: some View {
        List {
            ForEach(viewModel.items, id: \.path) { item in
                NavigationLink(destination: WebView(url: item.path)) {
                    ItemView(item: item)
                        .onAppear {
                            viewModel.loadMoreIfNeeded(currentItem: item)
                        }
                }
                
            }
            if viewModel.loading {
                ProgressView()
            }
        }
        .navigationTitle("今日热点")
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(viewModel: ListViewModel())
    }
}
