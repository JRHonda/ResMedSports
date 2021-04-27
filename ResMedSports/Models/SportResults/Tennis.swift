//
//  Tennis.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/25/21.
//

import Foundation

public struct Tennis: CommonSport {
    
    public let publicationDate: String?
    public let loser: String?
    public let numberOfSets: Int?
    public let tournament: String?
    public let winner: String?
    
    public var summary: String {
        get {
            if let loser = loser,
               let numberOfSets = numberOfSets,
               let tournament = tournament,
               let winner = winner {
                return "\(tournament.trim()): \(winner.trim()) wins against \(loser.trim()) in \(numberOfSets) sets"
            }
            return "Tennis Result"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case publicationDate, numberOfSets, tournament, winner
        case loser = "looser"
    }
}
