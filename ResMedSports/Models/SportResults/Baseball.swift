//
//  Baseball.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/26/21.
//

import Foundation

struct Baseball: CommonSport {

    var publicationDate: String?
    var runsDifference: Int?
    var winner: String?
    var loser: String?
    
    var summary: String {
        get {
            if let winner = winner,
               let loser = loser,
               let runsDifference = runsDifference {
                return "\(winner.trim()) beats \(loser.trim()) by \(runsDifference) runs"
            }
            return "Baseball Result"
        }
    }

}
