//
//  ViewController_2.swift
//  Yeetipedia Demo
//
//  Created by Adam T. Cuellar on 2/19/19.
//  Copyright © 2019 Adam T. Cuellar. All rights reserved.
//

import UIKit

class ViewController_2: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func execute(_ sender: Any)
    {
        contentRequest() { (result, error) in
            if let result = result {
                self.parseInfo(dict:result)
                print(result)
            } else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    func parseInfo(dict:[String:Any]) -> Void
    {
        print("Parse info: \(dict)")
        for (key,value) in dict
        {
            if key == "sections"
            {
                print("!!!!!!!!!!",value)
                DispatchQueue.main.async { self.sectionTile.text = "Hello World" /* value as? String */ }
            }
            
        }
    }
    
    func contentRequest(/* dict: inout [String:Any] ,*/ completion: @escaping ([String: Any]?, Error?) -> Void)
    {
        //create the url with NSURL
        let url = URL(string: "https://www.yeetdog.com/Cory_Test_Folder/ResponseTest.php")!
        
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
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    completion(nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
                    return
                }
                // print(json)
                completion(json, nil)
            } catch let error {
                print(error.localizedDescription)
                completion(nil, error)
            }
        })
        
        task.resume()
    }
    
    @IBOutlet weak var sectionTile: UILabel!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
