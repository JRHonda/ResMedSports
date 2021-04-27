//
//  Nba.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/25/21.
//

import Foundation

public struct Nba: CommonSport {

    public let publicationDate: String?
    public let gameNumber: Int?
    public let loser: String?
    public let mvp: String?
    public let tournament: String?
    public let winner: String?
    
    public var summary: String {
        get {
            if let gameNumber = gameNumber,
               let mvp = mvp,
               let tournament = tournament,
               let winner = winner {
                return "\(mvp.trim()) leads \(winner.trim()) to game \(gameNumber) in the \(tournament.trim())"
            }
            return "NBA Result"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case publicationDate, gameNumber, mvp, tournament, winner
        case loser = "looser"
    }
}
