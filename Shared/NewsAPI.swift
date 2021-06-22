//
//  NewsAPI.swift
//  WangYiNews
//
//  Created by Kiyan Gauss on 6/22/21.
//

import Foundation
import Combine


final class NewsAPI {
    private static let baseUrl = "https://api.apiopen.top"
    
    static func getList(page: Int = 1, count: Int = 20) -> AnyPublisher<[Item], NewsError> {
        var urlComponents = URLComponents(string: baseUrl)!
        urlComponents.path = "/getWangYiNews"
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "count", value: String(count)),
        ]
        return URLSession.shared.dataTaskPublisher(for: urlComponents.url!)
            .tryMap { (data, response) in
                if let httpURLResponse = response as? HTTPURLResponse,
                      !(200...299 ~= httpURLResponse.statusCode) {
                    throw NewsError.message("Got an HTTP \(httpURLResponse.statusCode) error.")
                }
                return data
            }
            .decode(type: ResponseList.self, decoder: JSONDecoder())
            .map{ $0.result }
            .mapError { NewsError.map($0) }
            .eraseToAnyPublisher()
    }
}
