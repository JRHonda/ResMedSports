//
//  Date+extensions.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/25/21.
//

import Foundation

extension Date {
    func convertToMonthDayYearString() -> String? {
        return DateFormatter.monthDayYearFormatter.string(from: self)
    }
}
