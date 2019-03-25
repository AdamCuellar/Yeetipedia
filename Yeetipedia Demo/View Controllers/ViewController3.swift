//
//  ViewController3.swift
//  Yeetipedia Demo
//
//  Created by Adam T. Cuellar on 3/6/19.
//  Copyright © 2019 Adam T. Cuellar. All rights reserved.
//

import UIKit

class ViewController3: UIViewController {

    var pageInfo = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* contentRequest() { (result, error) in
            if let result = result {
                // print(result)
            } else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        } */
        
        parseInfo(array: pageInfo)
    }
    
    // change UI based on pageInfo passed
    func parseInfo(array : [[String:Any]]) -> Void
    {
        print(array)
        for (key,value) in array[0]
        {
            if key == "section_title"
            {
                sectionTitle.text = value as? String
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
                
                // get sections from JSON
                let sections = json["sections"] as? [[String:Any]]
                
                // print(json)
                
                DispatchQueue.main.async
                {
                    self.pageInfo = sections!
                    self.parseInfo(array: self.pageInfo)
                }
                completion(json, nil)
            } catch let error {
                print(error.localizedDescription)
                completion(nil, error)
            }
        })
        
        task.resume()
    }

    @IBOutlet weak var sectionTitle: UILabel!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
