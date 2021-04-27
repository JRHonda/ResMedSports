//
//  AWAPIError.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/26/21.
//

import Foundation

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
