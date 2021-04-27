//
//  Service.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/25/21.
//

import Foundation

/// General service for all HTTP calls
class Service {
    
    // MARK: - Properties
    let networkClient: AncientWoodAPI
    let session: URLSession
    
    // MARK: - Initializers
    init(client: AncientWoodAPI) {
        networkClient = client
        session = URLSession(configuration: .default)
    }
    
    // MARK: - Internal
    
    /// Create an HTTP request and send it
    /// - Parameters:
    ///   - request: Supports any type of request
    ///   - completion: Returns a response and/or error
    func makeAndProcessRequest<R: Request>(
        request: R,
        completion: @escaping (Result<R.Response, AWAPIError>) -> Void) {
        
        let handleResponse: (Result<R.Response, AWAPIError>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        guard let urlRequest = prepare(request: request) else {
            return
        }
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                handleResponse(.failure(.requestFailed(error, statusCode)))
                return
            }
            
            do {
                if let data = data {
                    let value = try request.handle(response: data)
                    handleResponse(.success(value))
                    /* Can MOCK errored response here - uncomment next line */
                    // handleResponse(.failure(.noData))
                } else {
                    handleResponse(.failure(.noData))
                }
            } catch let handleError as NSError {
                handleResponse(.failure(.processingError(handleError)))
            }
        }
        task.resume()
    }
    
    
    /// Prepares a request to make a HTTP call
    /// - Parameter request: Supports any type of request
    /// - Returns: A URLRequest to provide to an HTTP task
    func prepare<R: Request>(request: R) -> URLRequest? {
        let pathURL = networkClient.environment.baseURL.appendingPathComponent(request.path)
        
        let components = URLComponents(url: pathURL,
                                       resolvingAgainstBaseURL: false)
        
        guard let url = components?.url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        // body *needs* to be the last property that we set, because of this bug: https://bugs.swift.org/browse/SR-6687
        urlRequest.httpBody = request.body
        
        let headers = [networkClient.contentTypeHeader]
        
        headers.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        return urlRequest
    }
}
