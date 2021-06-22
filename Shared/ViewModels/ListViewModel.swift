//
//  ListViewModel.swift
//  WangYiNews
//
//  Created by Kiyan Gauss on 6/22/21.
//

import Foundation
import Combine

public class ListViewModel: ObservableObject {
    var subscriptions: Set<AnyCancellable> = []
    @Published var loading: Bool = false
    @Published var error: NewsError?
    @Published var items: [Item] = []
    var page = 1
    var canLoadMore = true
    
    init() {
        loadMore()
    }
    
    func reload() {
        page = 1
        canLoadMore = true
        loadMore()
    }
    
    func loadMore() {
        guard !loading && canLoadMore else {
            return
        }
        
        loading = true
        NewsAPI.getList(page: page)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                if case let .failure(error) = value {
                    self.error = error
                }
                self.loading = false
            }, receiveValue: { [weak self] items in
                guard let self = self else { return }
                if items.count == 0 {
                    self.canLoadMore = false
                    return
                }
                self.items.append(contentsOf: items)
                self.page += 1
                
            })
            .store(in: &subscriptions)
    }
    func loadMoreIfNeeded(currentItem item: Item) {
        if !canLoadMore {
            return
        }
        let thresholdIndex = items.index(items.endIndex, offsetBy: -5)
        if items.firstIndex(where: { $0.path == item.path }) == thresholdIndex {
            loadMore()
        }
    }
}
