//
//  GigController.swift
//  Gigs
//
//  Created by Jake Connerly on 8/7/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation

class AuthenticationController {
    
    //
    //MARK: - HTTPMethod Enum
    //
    
    enum HTTPMethod: String {
        case get    = "GET"
        case put    = "PUT"
        case post   = "POST"
        case delete = "DELETE"
    }
    
    //
    //MARK: - Properties
    //
    
    var bearer: Bearer?
    
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
}
