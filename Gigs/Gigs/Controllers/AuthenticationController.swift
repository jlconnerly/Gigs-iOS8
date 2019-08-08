//
//  GigController.swift
//  Gigs
//
//  Created by Jake Connerly on 8/7/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation

class GigController {
    
    //
    //MARK: - HTTPMethod Enum
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
    
    var gigs: [Gig] = []
    
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    //
    //MARK: - SignUp Auth Function
    //
    
    func signUp(username: String, password: String, completion: @escaping (Error?) -> Void) {
        
        let signUpURL = baseURL.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let user = User(username: username, password: password)
        
        do {
            let userData = try JSONEncoder().encode(user)
            request.httpBody = userData
        }catch {
            NSLog("error encoding Urser: \(error)")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                NSLog("Error: Status code is not 200. Status code is: \(response.statusCode)")
            }
            
            if let error = error {
                NSLog("Error creating user: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    //
    //MARK: - SignIn Auth Function
    //
    
    func signIn(with username: String, password: String, completion: @escaping (Error?) -> Void) {
        let loginURL = baseURL.appendingPathComponent("users/login")
        
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let user = User(username: username, password: password)
        
        do {
            let userData = try JSONEncoder().encode(user)
            request.httpBody = userData
        } catch {
            NSLog("error encoding Urser: \(error)")
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
            
            guard let data = data else {
                NSLog("NO data returned")
                completion(NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let bearer = try jsonDecoder.decode(Bearer.self, from: data)
                self.bearer = bearer
                completion(nil)
            } catch {
                NSLog("Error decoding token: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
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
    
    func createGig(with title: String, dueDate: Date, description: String, completion: @escaping (Error?) -> Void ) {
        guard let bearer = bearer else {
            NSLog("Error with bearer token")
            return
        }
        let createGigURL = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: createGigURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let gig = Gig(title: title, dueDate: dueDate, description: description)
        
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
            
            self.gigs.append(gig)
            

            
                completion(nil)
            }.resume()
    }
}
