//
//  SportResultsService.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/25/21.
//

import Foundation

class SportResultsService: Service {
    
    // MARK: - Internal
    
    /// Method to request sport results
    /// - Parameter completion: Returns a fully decoded representation of the results or an error
    func getResults(completion: @escaping (_ response: Result<SportResultStructure, AWAPIError>) -> Void) {
      let request = MakeSportResultsRequest()
      makeAndProcessRequest(request: request,
                            completion: completion)
    }
    
}
