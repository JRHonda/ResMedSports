//
//  SportResultsVM.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/25/21.
//

import Foundation
import Combine

class SportResultsVM {
    
    // MARK: - Properties
    let sportResultService: SportResultsService
    var orderedSportResultsDictWithDateKeys = CurrentValueSubject<([String: [CommonSport]]?, [String]?), Never>((nil, nil))
    var apiErrorOccured = PassthroughSubject<AWAPIError, Never>()
    
    // MARK: - Initializers
    init(sportResultService: SportResultsService = .init(client: AncientWoodAPI())) {
        self.sportResultService = sportResultService
    }
    
    // MARK: - Internal
    
    /// Kicks off an HTTP request to retrieve sport results from the '/results' endpoint
    func getGroupedAndOrderedSportResults() {
        return sportResultService.getResults { (result) in
            switch result {
            case .success(let structure):
                self.orderedSportResultsDictWithDateKeys.send(self.buildOrderedResults(sportResults: structure))
            case .failure(let error):
                self.apiErrorOccured.send(error)
            }
        }
    }
    
    /// Takes sports results with date information and performs any combination of descending or ascending order for group
    /// date of sport results and the group of sport results themselves.
    /// - Parameter sportResults: Fully decoded sport results
    /// - Returns: An ordered-by-date dictionary with date-ordered sport results, and an associated array of date keys - ordered as well.
    private func buildOrderedResults(sportResults: SportResultStructure, sportsDescending: Bool = true) -> ([String: [CommonSport]]?, [String]?) {
        
        let allSportResults = sportResults.getAllSportResultsFlattened()
        
        if allSportResults.isEmpty {
            print("No sport results to display")
            return (nil, nil)
        }
        
        var shortenedDateSet = Set<String>()
        
        allSportResults.forEach { (sport) in
            if let shortenedDateStr = sport.publicationDate?.convertPublicationDateToShortDateString() {
                shortenedDateSet.insert(shortenedDateStr)
            }
        }
        
        let sortedKeyDates = sortKeyDates(dateSet: shortenedDateSet)
        
        var orderedDict = [String: [CommonSport]]()
        shortenedDateSet.forEach { (shortDate) in
            // for each date key, sort the sport results
            orderedDict[shortDate] = allSportResults
                .filter({ $0.publicationDate?.convertPublicationDateToShortDateString() == shortDate})
                .sorted(by: { (sport1, sport2) -> Bool in
                    if let pubDateStr1 = sport1.publicationDate,
                       let pubDateStr2 = sport2.publicationDate,
                       let pubDate1 = pubDateStr1.toDate(),
                       let pubDate2 = pubDateStr2.toDate() {
                        if sportsDescending {
                            return pubDate1 > pubDate2
                        }
                        return pubDate1 < pubDate2
                    }
                    return false
                })
        }
        return (orderedDict, sortedKeyDates)
    }
    
    /// Takes date strings, transforms them to Date, and orders dates by ascending or descending order.
    /// - Parameters:
    ///   - dateSet: A Set of type string to order
    ///   - descending: Boolean to set order to descending or ascending. Default == true
    /// - Returns: An ordered Array of type String, or nil
    private func sortKeyDates(dateSet: Set<String>, descending: Bool = true) -> [String] {
        return dateSet.sorted { (str1, str2) -> Bool in
            
            if let date1 = DateFormatter.monthDayYearFormatter.date(from: str1),
               let date2 = DateFormatter.monthDayYearFormatter.date(from: str2) {
                
                if descending {
                    return date1 > date2
                }
                return date1 < date2
            }
            return descending
        }
    }
    
}
