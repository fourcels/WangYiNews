//
//  NewsError.swift
//  WangYiNews
//
//  Created by Kiyan Gauss on 6/22/21.
//

import Foundation

enum NewsError: Error {
  case message(String)
  case other(Error)

  static func map(_ error: Error) -> NewsError {
    return (error as? NewsError) ?? .other(error)
  }
}

extension NewsError: CustomStringConvertible {
  var description: String {
    switch self {
    case .message(let message):
      return message
    case .other(let error):
      return error.localizedDescription
    }
  }
}
