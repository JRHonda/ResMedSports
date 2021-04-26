//
//  AncientWoodAPI.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/25/21.
//

import class Foundation.URLSession

typealias HTTPHeaders = [String: String]
typealias HTTPHeader = HTTPHeaders.Element

enum AWAPIError: Error {
  case requestFailed(Error?, Int)
  case processingError(Error?)
  case noData

  var localizedDescription: String {
    switch self {
    case .requestFailed(let error, let statusCode):
      return "AWAPIError::RequestFailed[Status: \(statusCode) | Error: \(error?.localizedDescription ?? "UNKNOWN")]"
    case .processingError(let error):
      return "AWAPIError::ProcessingError[Error: \(error?.localizedDescription ?? "UNKNOWN")]"
    case .noData:
      return "AWAPIError::NoData"
    }
  }
}

struct AncientWoodAPI {
    
    // MARK: - Properties
    let environment: AncientWoodEnvironment
    let session: URLSession
    
    // MARK: - HTTP Headers
    let contentTypeHeader: HTTPHeader = ("Content-Type", "application/json; charset=utf-8")
    
    // MARK: - Initializers
    init(
        session: URLSession = .init(configuration: .default),
        environment: AncientWoodEnvironment = .prod
    ) {
        self.session = session
        self.environment = environment
    }
}
