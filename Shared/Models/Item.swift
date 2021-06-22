//
//  Item.swift
//  WangYiNews
//
//  Created by Kiyan Gauss on 6/22/21.
//

import Foundation


struct ResponseList: Codable {
    var result: [Item]
    var code: Int
    var message: String
}

struct Item: Codable, Hashable {
    let path: String
    let image: String
    let title: String
    let passtime: String
}
