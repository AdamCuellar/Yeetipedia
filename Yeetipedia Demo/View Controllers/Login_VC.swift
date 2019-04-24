//
//  ViewController.swift
//  Yeetipedia Demo
//
//  Created by Adam T. Cuellar on 2/19/19.
//  Copyright © 2019 Adam T. Cuellar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var table_of_contents_info = [[String:Any]]()

    @IBOutlet weak var login_button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set background
        // view.addBackground(imageName: "backgroundCities.jpg")
        
        // add colored border to username and password text fields
        let fieldColor = UIColor.black
        username.layer.borderColor = fieldColor.cgColor
        password.layer.borderColor = fieldColor.cgColor
        
        // set style for the button
        login_button.layer.cornerRadius = 5; // this value vary as per your desire
        login_button.clipsToBounds = true
        
        setupKeyboardDismissRecognizer()
        
    }
    
    // go to sign up segue
    @IBAction func goToSignUp(_ sender: Any)
    {
        self.performSegue(withIdentifier:"login_to_signup", sender:nil)
    }
    
    // attempt log in
    @IBAction func logIn(_ sender: Any)
    {
        // make sure both username and password fields are not empty
        // ADD: check if its a successful log in, if it isn't add a popup that says so
        if(!(username.text == "" || password.text == ""))
        {
            let user : String = username.text!
            let pass : String = password.text!
            
            // call postRequest with username and password parameters
            postRequest(username: user, password: pass) { (result, error) in
                if result?["state"] as! Int == 1
                {
                    // request content
                    self.table_of_contents_request() { (result, error) in
                        if result != nil
                        {
                            DispatchQueue.main.async
                            {
                                self.performSegue(withIdentifier:"login_to_toc", sender:nil)
                            }
                        } else if let error = error {
                            print("error: \(error.localizedDescription)")
                        }
                    }
                }
                else if result?["state"] as! Int == 2
                {
                    DispatchQueue.main.async
                    {
                        let alert = UIAlertController(title: "Error", message: "The password you've entered does not match.", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
                else if result?["state"] as! Int == 0
                {
                    DispatchQueue.main.async
                    {
                        let alert = UIAlertController(title: "Error", message: "The username does not exist.", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                        
                        self.present(alert, animated: true)
                    }
                }
                else
                {
                    DispatchQueue.main.async
                    {
                        let alert = UIAlertController(title: "Error", message: "There was an issue Yeeting in.", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                        
                        self.present(alert, animated: true)
                    }
                }
            }
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "Please enter a username and password.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }

    }
    

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    
    func postRequest(username: String, password: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        
        //declare parameter as a dictionary which contains string as key and value combination.
        let parameters = ["username": username, "password": password]
        
        //create the url with NSURL
        let url = URL(string: "https://www.yeetdog.com/Yeetipedia/login.php")!
        
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
    
    // request content of desired page
    func table_of_contents_request(/* dict: inout [String:Any] ,*/ completion: @escaping ([String: Any]?, Error?) -> Void)
    {
        //create the url with NSURL
        let url = URL(string: "https://www.yeetdog.com/Yeetipedia/query_pages.php")! //Cory_Test_Folder/Test_ToC_Response.php")!
        
        //create the session object
        let session = URLSession.shared
        
        //now create the Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: [] , options: .prettyPrinted) // pass dictionary to data object and set it as request body
            print(try JSONSerialization.data(withJSONObject: [] , options: .prettyPrinted))
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
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                else {
                    completion(nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
                    return
                }
                
                // parses out the json to the arrays inside of the "pages" index
                
                
                let pages = json["pages"] as? [[String:Any]]
                print("PRINTING JSON \(json)")
                
                //print("pages:\n \(String(describing: pages))")
                
                DispatchQueue.main.async {
                    self.table_of_contents_info = pages!
                }
                
                completion(json, nil)
            } catch let error {
                print("error in table of contents request")
                print(error.localizedDescription)
                completion(nil, error)
            }
        })
        
        task.resume()
    }
    
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login_to_toc" {
            if let navigationVC = segue.destination as? UINavigationController, let myViewController = navigationVC.topViewController as? ToC_VC {
                myViewController.cellInfoArray = createCellInfoArray()
            }
        }
        if segue.identifier == "login_to_testingTable" {
            if let navigationVC = segue.destination as? UINavigationController, let myViewController = navigationVC.topViewController as? TestingTable {
                myViewController.cellInfoArray = createCellInfoArray()
            }
            
        }
    }
    
    func createCellInfoArray () -> [CellInfo] {
        // since the inner array will have the same parameters each time (Title, Author, maybe summary)
        var cellInfoArray = [CellInfo]();
        
        for i in 0..<table_of_contents_info.count {
            //let cellInfo = CellInfo(title: table_of_contents_info[0][0][1], author: "Steve");
            let cellInfo = CellInfo(id: table_of_contents_info[i]["id"] as? Int ?? -1, title: table_of_contents_info[i]["title"] as? String ?? "", description: table_of_contents_info[i]["description"] as? String ?? "")
            print("\(String(describing: table_of_contents_info[i]["title"]))")
           cellInfoArray.append(cellInfo)
        }
        
        return cellInfoArray
    }
    
    func setupKeyboardDismissRecognizer(){
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        
        tapRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
}
/*
 ["pages": <__NSArrayM 0x6000034d0b70>(
 <__NSArrayM 0x6000034d1950>(
    {id = 1;},
    {title = test;},
    {description = "This test content, has been edited via EditTestSections.php";}
 ),
 <__NSArrayM 0x6000034d2460>(
    {id = 2;},
    {title = abc;},
    {}
 )
 )]
 
 ["pages": <__NSArrayM 0x6000025ef6c0>(
 {
    index = 1;
    "page_author" = "Robert Sherlock Holmes";
    "page_title" = "Robohands are GARBAGE";
 },
 {
    index = 2;
    "page_author" = "Will B. Buttlicker";
    "page_title" = "Dogs make great robots";
 },
 {
    index = 3;
    "page_author" = "Samuel L. Jackson";
    "page_title" = "Where to put your super suit";
 }
 )
 , "page_title": Table of Contents, "page_information": This is a list of the pages available]
 */
