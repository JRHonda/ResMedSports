//
//  String+extensions.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/25/21.
//

import Foundation

extension String {
    
    func toDate() -> Date? {
        return DateFormatter.dateFormatter.date(from: self)
    }
    
    func convertPublicationDateToShortDateString() -> String {
        if let dateToShorten = DateFormatter.dateFormatter.date(from: self) {
            return dateToShorten.convertToMonthDayYearString() ?? self
        }
        return self
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
