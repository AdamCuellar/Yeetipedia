//
//  ViewController2.swift
//  Yeetipedia Demo
//
//  Created by Adam T. Cuellar on 3/6/19.
//  Copyright © 2019 Adam T. Cuellar. All rights reserved.
//

import UIKit

class ViewController2: UITableViewController {
    
    // double array from json in table of contents
    var table_of_contents_info = [[String:Any]]()
    var table_of_contents_num_sections = Int()
    
    var testing = [String]()
    
    // double array for json loaded for page that will be selected
    var pageInfo = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //testing=[["Hello", "World"],["What's","Up"]];
        testing=["Hello","World","What's","Up"]
        
        tableView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.reloadData()

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return table_of_contents_num_sections
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PagesCell", for: indexPath)
        
        print("CELLFORROWAT: \(indexPath.row)")
//        let cellContent = testing[indexPath.row];
//        cell.textLabel?.text = cellContent
//        let pages = Pages(info: table_of_contents_info[indexPath.row])
//
//        cell.page = pages
//        cell.selectionStyle = .none
        
        
        return cell

    }
    
    
    @IBAction func goNext(_ sender: Any)
    {
        // request content
        contentRequest() { (result, error) in
            if result != nil
            {
                DispatchQueue.main.async
                {
                    self.performSegue(withIdentifier: "segueIdentifier2", sender: nil)
                }
            } else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueIdentifier2"
        {
            if let content = segue.destination as? TableViewController
            {
                content.pageInfo = self.pageInfo
                content.numSections = self.pageInfo.count
            }
        }
    }
    
    // request content of desired page
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
                
                let sections = json["sections"] as? [[String:Any]]
                // print(json)
                
                DispatchQueue.main.async {
                    self.pageInfo = sections!
                }
                
                completion(json, nil)
            } catch let error {
                print(error.localizedDescription)
                completion(nil, error)
            }
        })
        
        task.resume()
    }

}
