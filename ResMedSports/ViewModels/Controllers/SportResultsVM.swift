//
//  SportResultsVM.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/25/21.
//

import Foundation
import Combine

class SportResultsVM {
    
    let sportResultService: SportResultsService
    
    @Published var orderedSportResultsDictWithDateKeys: ([String: [CommonSport]]?, [String]?)
    
    init(sportResultService: SportResultsService = .init(client: AncientWoodAPI())) {
        self.sportResultService = sportResultService
    }
   
    func getGroupedAndOrderedSportResults() {
        
        sportResultService.getResults { (result) in
            switch result {
            case .success(let structure):
                self.orderedSportResultsDictWithDateKeys = self.buildOrderedResults(sportResults: structure)
            case .failure(_):
                self.orderedSportResultsDictWithDateKeys = (nil, nil)
            }
        }
    }
    
    private func buildOrderedResults(sportResults: SportResultStructure) -> ([String: [CommonSport]]?, [String]?) {
        
        var orderedDict = [String: [CommonSport]]()
        
        let commonSports = [sportResults.f1Results, sportResults.nbaResults, sportResults.tennisResults]
        
        let flattenedSports = commonSports.flatMap { (sports) -> [CommonSport] in
            return sports ?? []
        }
        
        if flattenedSports.isEmpty {
            print("Flatten operation did not work")
            return (nil, nil)
        }
        
        var shortenedDateSet = Set<String>()
        
        flattenedSports.forEach { (sport) in
            if let shortenedDateStr = sport.publicationDate?.convertPublicationDateToShortDateString() {
                shortenedDateSet.insert(shortenedDateStr)
            }
        }
        
        if let sortedKeyDates = sortKeyDates(dateSet: shortenedDateSet) {
            shortenedDateSet.forEach { (shortDate) in
                orderedDict[shortDate] = flattenedSports
                    .filter({ $0.publicationDate?.convertPublicationDateToShortDateString() == shortDate})
                    .sorted(by: { (sport1, sport2) -> Bool in
                        if let pubDateStr1 = sport1.publicationDate,
                           let pubDateStr2 = sport2.publicationDate,
                           let pubDate1 = pubDateStr1.toDate(),
                           let pubDate2 = pubDateStr2.toDate() {
                            return pubDate1 > pubDate2
                        }
                        return false
                    })
            }
            return (orderedDict, sortedKeyDates)
        }
        return (nil, nil)
    }
    
    private func sortKeyDates(dateSet: Set<String>, descending: Bool = true) -> [String]? {
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
