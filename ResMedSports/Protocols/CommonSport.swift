//
//  CommonSport.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/25/21.
//

import Foundation

protocol CommonSport: Codable {
    var publicationDate: String? { get }
    var summary: String { get }
}

extension CommonSport {
    var time: String {
        get {
            if let publicationDate = publicationDate,
               let date = DateFormatter.dateFormatter.date(from: publicationDate) {
            
                return DateFormatter.prettyTimeFormatter.string(from: date)
            }
            return "\(Calendar.current.timeZone.identifier)"
        }
    }
}
