//
//  DateFormatter+extensions.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/25/21.
//

import Foundation

extension DateFormatter {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy h:mm:ss a"
        formatter.timeZone = TimeZone(abbreviation: "en_POSIX_US")
        return formatter
    }()
    
    static let monthDayYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        formatter.timeZone = TimeZone(abbreviation: "en_POSIX_US")
        return formatter
    }()
    
    static let prettyTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm:ss a"
        formatter.timeZone = TimeZone(abbreviation: "en_POSIX_US")
        return formatter
    }()
    
}
