//
//  F1.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/25/21.
//

import Foundation

public struct F1: CommonSport {

    public let publicationDate: String?
    public let seconds: Double?
    public let tournament: String?
    public let winner: String?
    
    public var summary: String {
        get {
            if let winner = winner, let tournament = tournament, let seconds = seconds {
                return "\(winner.trim()) wins \(tournament.trim()) by \(seconds) seconds"
            }
            return "F1 Result"
        }
    }
    
}
