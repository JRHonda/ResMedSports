//
//  SportResultStructure.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/25/21.
//

import Foundation

public struct SportResultStructure: Decodable {

    // MARK: - Properties
    var f1Results: [CommonSport]
    var nbaResults: [CommonSport]
    var tennisResults: [CommonSport]
    var baseballResults: [CommonSport]
    
    // MARK: - Initializers
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        f1Results = try container.decodeIfPresent([F1].self, forKey: .f1Results) ?? []
        nbaResults = try container.decodeIfPresent([Nba].self, forKey: .nbaResults) ?? []
        tennisResults = try container.decodeIfPresent([Tennis].self, forKey: .tennis) ?? []
        baseballResults = try container.decodeIfPresent([Baseball].self, forKey: .baseball) ?? []
    }
    
    // MARK: - Internal
    
    /// Takes all sport results decoded and flattens them to a single sequence
    /// - Returns: An array of sport results
    func getAllSportResultsFlattened() -> [CommonSport] {
        
        let commonSports = [f1Results, nbaResults, tennisResults, baseballResults]
        
        return commonSports.flatMap { return $0 }
    }
    
    enum CodingKeys: String, CodingKey {
        case f1Results
        case nbaResults
        case tennis = "Tennis"
        case baseball
    }
    
}
