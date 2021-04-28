//
//  ResMedSportsTests.swift
//  ResMedSportsTests
//
//  Created by Justin Honda on 4/25/21.
//

import XCTest
@testable import ResMedSports

class ResMedSportsTests: XCTestCase {
    
    var testJsonData: Data!
    let decoder = JSONDecoder()
    var sportResultStructure: SportResultStructure!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.testJsonData = """
        {"f1Results":[{"publicationDate":"May 9, 2020 8:09:03 PM","seconds":5.856,"tournament":"Silverstone Grand Prix","winner":"Lewis Hamilton"},{"publicationDate":"Apr 14, 2020 8:09:03 PM","seconds":7.729,"tournament":"VTB RUSSIAN GRAND PRIX","winner":"Valtteri Bottas"},{"publicationDate":"Mar 15, 2020 8:09:03 PM","seconds":5.856,"tournament":"Spa BELGIAN GRAND PRIX","winner":"Lewis Hamilton"}],"nbaResults":[{"gameNumber":6,"looser":"Heat","mvp":"Lebron James","publicationDate":"May 9, 2020 9:15:15 AM","tournament":"NBA playoffs","winner":"Lakers"},{"gameNumber":5,"looser":"Lakers","mvp":"Jimmy Butler","publicationDate":"May 7, 2020 3:15:00 PM","tournament":"NBA playoffs","winner":"Heat"},{"gameNumber":4,"looser":"Heat","mvp":"Anthony Davis","publicationDate":"May 5, 2020 1:34:15 PM","tournament":"NBA playoffs","winner":"Lakers"},{"gameNumber":3,"looser":"Lakers","mvp":"Jimmy Butler","publicationDate":"May 3, 2020 9:15:33 PM","tournament":"NBA playoffs","winner":"Heat"},{"gameNumber":2,"looser":"Heat","mvp":"Anthony Davis","publicationDate":"May 2, 2020 6:07:03 AM","tournament":"NBA playoffs","winner":"Lakers"}],"Tennis":[{"looser":"Schwartzman ","numberOfSets":3,"publicationDate":"May 9, 2020 11:15:15 PM","tournament":"Roland Garros","winner":"Rafael Nadal"},{"looser":"Stefanos Tsitsipas ","numberOfSets":3,"publicationDate":"May 9, 2020 2:00:40 PM","tournament":"Roland Garros","winner":"Novak Djokovic"},{"looser":"Petra Kvitova","numberOfSets":3,"publicationDate":"May 8, 2020 4:33:17 PM","tournament":"Roland Garros","winner":"Sofia Kenin"}]}
        """.data(using: .utf8)!
        
        self.sportResultStructure = try decoder.decode(SportResultStructure.self, from: testJsonData!)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSportResultStructureDecoding() throws {
        XCTAssertNotNil(sportResultStructure)
        XCTAssertEqual(sportResultStructure.baseballResults.count, 0)
        XCTAssertEqual(sportResultStructure.f1Results.count, 3)
        XCTAssertEqual(sportResultStructure.nbaResults.count, 5)
        XCTAssertEqual(sportResultStructure.tennisResults.count, 3)
        XCTAssertEqual(sportResultStructure.getAllSportResultsFlattened().count, 11)
    }
    
    func testConvertCommonSportToSomeSport() throws {
        let f1Results = sportResultStructure.f1Results
        var isTestSuccessful = false
        
        if let f1ConcreteResult = f1Results
            .first(where: { (f1CommonSportResult) -> Bool in
                f1CommonSportResult.publicationDate == "May 9, 2020 8:09:03 PM"
            })
            .map({ (f1CommonSportResult) -> F1? in
                return f1CommonSportResult as? F1
            }) {
            XCTAssertNotNil(f1ConcreteResult)
            XCTAssertEqual(f1ConcreteResult?.publicationDate?.trim(), "May 9, 2020 8:09:03 PM")
            XCTAssertEqual(f1ConcreteResult?.seconds, 5.856)
            XCTAssertEqual(f1ConcreteResult?.winner?.trim(), "Lewis Hamilton")
            XCTAssertEqual(f1ConcreteResult?.tournament?.trim(), "Silverstone Grand Prix")
            isTestSuccessful = true
        }
        
        if !isTestSuccessful {
            assertionFailure("Unable to cast generic CommonSport to concrete F1")
        }
    }
    
    func testBuildArrayOfCommonSportResultsToConcreteVersions() throws {
       
        let flattenedSportResults = sportResultStructure.getAllSportResultsFlattened()
        
        var nbaResults = [Nba]()
        var f1Results = [F1]()
        var tennisResults = [Tennis]()
        
        flattenedSportResults.forEach {
            if $0 is F1 {
                f1Results.append($0 as! F1)
            }
            if $0 is Nba {
                nbaResults.append($0 as! Nba)
            }
            if $0 is Tennis {
                tennisResults.append($0 as! Tennis)
            }
        }
        
        XCTAssertEqual(nbaResults.count, 5)
        XCTAssertEqual(f1Results.count, 3)
        XCTAssertEqual(tennisResults.count, 3)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            do {
                //try testConvertCommonSportToSomeSport()
                try testBuildArrayOfCommonSportResultsToConcreteVersions()
            } catch {
                
            }
        }
    }
    
}

