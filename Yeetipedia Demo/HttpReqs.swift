//
//  HttpReqs.swift
//  Yeetipedia Demo
//
//  Created by Adam T. Cuellar on 4/19/19.
//  Copyright © 2019 Adam T. Cuellar. All rights reserved.
//

import Foundation

class HTTP_Request
{
    func signUpPost(username: String, password: String, confirmPass: String, completion: @escaping ([String: Any]?, Error?) -> Void)
    {
        //declare parameter as a dictionary which contains string as key and value combination.
        let parameters = ["username": username, "password": password, "password_confirm" : confirmPass]
        
        //create the url with NSURL
        let url = URL(string: "https://www.yeetdog.com/Yeetipedia/signup.php")!
        
        //create the session object
        let session = URLSession.shared
        
        //now create the Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to data object and set it as request body
            print(try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted))
        } catch let error {
            print(error.localizedDescription)
            completion(nil, error)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }
            
            do {
                //create json object from data
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    completion(nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
                    return
                }
                print("JSON INFORMATION: \(json)")
                completion(json, nil)
            } catch let error {
                print("error in post request")
                print(error.localizedDescription)
                completion(nil, error)
            }
        })
        
        task.resume()
        
    }
    
    func postRequest(username: String, password: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        
        //declare parameter as a dictionary which contains string as key and value combination.
        let parameters = ["username": username, "password": password]
        
        //create the url with NSURL
        let url = URL(string: "https://www.yeetdog.com/ContactProject/login.php")!
        
        //create the session object
        let session = URLSession.shared
        
        //now create the Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to data object and set it as request body
            print(try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted))
        } catch let error {
            print(error.localizedDescription)
            completion(nil, error)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }
            
            do {
                //create json object from data
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    completion(nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
                    return
                }
                print("JSON INFORMATION: \(json)")
                completion(json, nil)
            } catch let error {
                print("error in post request")
                print(error.localizedDescription)
                completion(nil, error)
            }
        })
        
        task.resume()
    }
    
}
