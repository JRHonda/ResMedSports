//
//  Request.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/25/21.
//

import Foundation

enum HTTPMethod: String {
  case GET
  case POST
  case PUT
  case DELETE
  case PATCH
}

protocol Request {
  associatedtype Response

  var method: HTTPMethod { get }
  var path: String { get }
  var additionalHeaders: [String: String] { get }
  var body: Data? { get }

  func handle(response: Data) throws -> Response
}

// Default implementation to .GET
extension Request {
  var method: HTTPMethod { .GET }
}

