//
//  SignUpVC.swift
//  Yeetipedia Demo
//
//  Created by Adam T. Cuellar on 4/18/19.
//  Copyright © 2019 Adam T. Cuellar. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    var table_of_contents_info = [[String:Any]]()

    var http = HTTP_Request()

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set background
         view.addBackground(imageName: "backgroundWoman.png")
        
        // add colored border to username and password text fields
        let fieldColor = UIColor.black
        username.layer.borderColor = fieldColor.cgColor
        password.layer.borderColor = fieldColor.cgColor
        confirmPass.layer.borderColor = fieldColor.cgColor
        
    }
    
    @IBAction func signUp(_ sender: Any)
    {
        if(!(username.text == "" || password.text == "" || confirmPass.text == ""))
        {
            let user : String = username.text!
            let pass : String = password.text!
            let confirm : String = confirmPass.text!
            
            // call post request to sign up
            http.signUpPost(username: user, password: pass, confirmPass: confirm)
            { (result, error) in
                if result!["state"] as? Int == 1
                {
                    // request content
                    self.table_of_contents_request() { (result, error) in
                        if result != nil
                        {
                            DispatchQueue.main.async
                            {
                                self.performSegue(withIdentifier:"loginAfterUp", sender:nil)
                            }
                        } else if let error = error {
                            print("error: \(error.localizedDescription)")
                        }
                    }
                } else if let error = error {
                    print("error: \(error.localizedDescription)")
                }
                else
                {
                    print("error")
                }
            }
        }
        else
        {
            print("didn't try to sign up");
        }
    }

    // request content of desired page
    func table_of_contents_request(/* dict: inout [String:Any] ,*/ completion: @escaping ([String: Any]?, Error?) -> Void)
    {
        //create the url with NSURL
        let url = URL(string: "https://www.yeetdog.com/Yeetipedia/query_pages.php")!
        
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
                print("pages:\n \(String(describing: pages))")
                
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
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
         if segue.identifier == "loginAfterUp"
        {
            if let navigationVC = segue.destination as? UINavigationController, let myViewController = navigationVC.topViewController as? TestingTable
            {
                myViewController.cellInfoArray = createCellInfoArray()
            }
         }
    }
    
    func createCellInfoArray () -> [CellInfo]
    {
        // since the inner array will have the same parameters each time (Title, Author, maybe summary)
        var cellInfoArray = [CellInfo]();
        
        for i in 0..<table_of_contents_info.count
        {
            let cellInfo = CellInfo(id: table_of_contents_info[i]["id"] as? Int ?? -1, title: table_of_contents_info[i]["title"] as? String ?? "", description: table_of_contents_info[i]["description"] as? String ?? "")
            print("\(String(describing: table_of_contents_info[i]["title"]))")
            cellInfoArray.append(cellInfo)
        }
        
        return cellInfoArray
    }


}
