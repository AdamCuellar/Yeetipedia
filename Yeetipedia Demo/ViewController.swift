//
//  ViewController.swift
//  Yeetipedia Demo
//
//  Created by Adam T. Cuellar on 2/19/19.
//  Copyright © 2019 Adam T. Cuellar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addBackground(imageName: "backgroundCities.jpg")
        
        let fieldColor = UIColor.black
        username.layer.borderColor = fieldColor.cgColor
        
        password.layer.borderColor = fieldColor.cgColor
        
    }
    
    @IBAction func logIn(_ sender: Any)
    {
        if(!(username.text == "" || password.text == ""))
        {
            let user : String = username.text!
            let pass : String = password.text!
            
            //call postRequest with username and password parameters
            postRequest(username: user, password: pass) { (result, error) in
                if let result = result {
                    print("Success: \(result)")
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "segueIdentifier", sender: nil)
                    }
                } else if let error = error {
                    print("error: \(error.localizedDescription)")
                }
            }
        }
        else
        {
            print("Error");
        }

    }
    

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    
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
                print(json)
                completion(json, nil)
            } catch let error {
                print(error.localizedDescription)
                completion(nil, error)
            }
        })
        
        task.resume()
    }
}

