//
//  GigController.swift
//  Gigs
//
//  Created by Jake Connerly on 8/8/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation

class GigController {
    
    //
    //MARK: - Enums
    //
    
    enum HTTPMethod: String {
        case get    = "GET"
        case put    = "PUT"
        case post   = "POST"
        case delete = "DELETE"
    }
    
    enum NetworkError: Error {
        case noAuth
        case badAuth
        case otherError(Error)
        case badData
        case noDecode
    }
    
    //
    //MARK: - Properties
    //
    
    var bearer: Bearer?
    
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    var gigs: [Gig] = []
    
    //
    //MARK: - Fetch All Gigs Method
    //
    
    func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("gigs")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(.failure(.otherError(error)))
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from fething all gigs:\(error)")
                completion(.failure(.badData))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let gigs = try decoder.decode([Gig].self, from: data)
                self.gigs = gigs
                completion(.success(gigs))
            }catch {
                NSLog("Error decoding gigs:\(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
    
    //
    //MARK: - Create Gig Method
    //
    
    func createGig(with gig: Gig, completion: @escaping (Error?) -> Void ) {
        guard let bearer = bearer else {
            NSLog("Error with bearer token")
            return
        }
        let createGigURL = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: createGigURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let gigData = try encoder.encode(gig)
            request.httpBody = gigData
        }catch {
            NSLog("Error creating gig:\(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                NSLog("Error: Status code is not 200. Status code is: \(response.statusCode)")
            }
            
            if let error = error {
                NSLog("Error creatin user: \(error)")
                completion(error)
                return
            }
            completion(nil)
            }.resume()
        
    }
    
}
