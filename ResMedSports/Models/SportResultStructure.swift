//
//  SportResultStructure.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/25/21.
//

import Foundation

public struct SportResultStructure: Decodable {

    var f1Results: [CommonSport]?
    var nbaResults: [CommonSport]?
    var tennisResults: [CommonSport]?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        f1Results = try container.decodeIfPresent([F1].self, forKey: .f1Results) ?? []
        nbaResults = try container.decodeIfPresent([Nba].self, forKey: .nbaResults) ?? []
        tennisResults = try container.decodeIfPresent([Tennis].self, forKey: .tennis) ?? []
    }
    
    enum CodingKeys: String, CodingKey {
        case f1Results
        case nbaResults
        case tennis = "Tennis"
    }
}
