//
//  SportResultsRequest.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/25/21.
//

import struct Foundation.Data
import class Foundation.JSONDecoder

struct MakeSportResultsRequest: Request {

    typealias Response = SportResultStructure
    
    // MARK: - Properties
    var method: HTTPMethod { .POST }
    var path: String { "/results" }
    var additionalHeaders: [String: String] = [:]
    var body: Data? { nil }
    
    // MARK: - Internal
    func handle(response: Data) throws -> SportResultStructure {
        //let json = String(bytes: response, encoding: .utf8)
        
        let decoder = JSONDecoder()
    
        do {
            let sportResultStructure = try decoder.decode(SportResultStructure.self, from: response)
            
            return sportResultStructure
        } catch {
            throw error
        }
    }
}

