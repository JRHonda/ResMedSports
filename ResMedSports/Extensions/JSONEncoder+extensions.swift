//
//  JSONEncoder+extensions.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/27/21.
//

import Foundation

extension JSONEncoder {
    // Type erasure
    func encode<S: Encodable>(sport: S) throws -> Data {
        self.outputFormatting = .prettyPrinted
        return try self.encode(sport)
    }
}
