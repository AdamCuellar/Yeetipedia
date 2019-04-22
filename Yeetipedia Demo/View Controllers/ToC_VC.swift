//
//  ToC_VC.swift
//  Yeetipedia Demo
//
//  Created by Boyce Estes on 4/20/19.
//  Copyright © 2019 Adam T. Cuellar. All rights reserved.
//

import UIKit

struct CellInfo {
    let id: Int
    let title: String
    let description: String
}

class Toc_cell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
}

class ToC_VC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var cellInfoArray = [CellInfo]()
    var searchResults = [CellInfo]()
    
    var searching : Bool = false
    
    // store the dictionary page chosen
    var pageInfo = [[String:Any]]()
    // pass the title of the chosen page to the
    var cellTitle = String()
    // prevents the cell from being pressed twice while info is loading in
    var clicked = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // required to implement UITableViewDataSource and UITableViewDelegate
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // required to implement UISearchBarDelegate
        self.searchBar.delegate = self
        
        // set height for table of contents to be dynamic
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 96
        
        // add a header for the table displaying the title of this page
        
        
        // logout button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TestingTable.logoutTapped(_:)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        clicked = false
    }
    
    // table setup functions
    
  
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searching) {
            return searchResults.count
        } else {
            return cellInfoArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toc_cell", for: indexPath) as! Toc_cell
        var cellInfo : CellInfo
        if (searching) {
            // called whenever we are entering text into the search bar
            cellInfo = searchResults[indexPath.row]
            
        } else {
            // called whenever we are not entering text in the search bar
            cellInfo = cellInfoArray[indexPath.row]
        }
        cell.title.text = cellInfo.title
        cell.desc.text = cellInfo.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (clicked == false) {
            clicked = true;
            // get the page ID of the selected row
            let cellID = cellInfoArray[indexPath.row].id
            let cellTitle = cellInfoArray[indexPath.row].title
            
            // we should store this particular user's permission level when they log in and use it here
            let access = 50
            
            let pageSelect : [String : Any] = ["id": cellID, "access":access]
            specific_page_request(dict: pageSelect, title: cellTitle) { (dict, error) in
                print("hello world")
                DispatchQueue.main.async
                    {
                        // self.performSegue(withIdentifier: "go_to_table_of_contents", sender: nil)
                        self.performSegue(withIdentifier:"toc_to_page", sender:nil)
                }
            }
        }
    }
    
    // logout
    @objc func logoutTapped(_ sender:UIBarButtonItem!) {
        print("logout tapped")
        DispatchQueue.main.async {
            // self.performSegue(withIdentifier: "go_to_table_of_contents", sender: nil)
            self.performSegue(withIdentifier:"toc_to_login", sender:nil)
        }
    }
    
    // get get clicked page data
    
    func specific_page_request(dict: [String:Any] , title: String, completion: @escaping ([String: Any]?, Error?) -> Void)
    {
        //create the url with NSURL
        let url = URL(string: "https://www.yeetdog.com/Yeetipedia/wikipage.php")!
        
        //create the session object
        let session = URLSession.shared
        
        //now create the Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: dict , options: .prettyPrinted) // pass dictionary to data object and set it as request body
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
                print("PRINTING JSON \(json)")
                let results = json["state"] as? Int
                if (results == 0) {
                    
                    let alertController = UIAlertController(title: "Cannot Access", message: "You do not have permission to view this page.", preferredStyle: .alert)
                    
                    let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                        print("pressed OK");
                    }
                    
                    let action2 = UIAlertAction(title: "OK but in another button", style: .cancel) { (action:UIAlertAction) in
                        print("You've pressed cancel");
                    }
                    
                    alertController.addAction(action1)
                    alertController.addAction(action2)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let sections = json["sections"] as? [[String:Any]]
                    print("print 2d array: \(String(describing: sections))")
                    // print(json)
                    
                    DispatchQueue.main.async {
                        self.pageInfo = sections!
                        self.cellTitle = title
                    }
                    completion(json, nil)
                }
            } catch let error {
                print("error in table of contents request")
                print(error.localizedDescription)
                completion(nil, error)
            }
        })
        
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toc_to_page" {
            
            if let nextVC = segue.destination as? TableViewController {
                nextVC.pageInfo = pageInfo
                nextVC.cellTitle = cellTitle
            }
        }
    }
    
    func printSearchResults () {
        print("print searchResults")
        for i in 0 ..< searchResults.count {
            print("\(i))\(searchResults[i].title)")
        }
    }
}

extension ToC_VC : UISearchBarDelegate {
    // search bar delegate setup
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("hello world: \(searchText)")
        searchResults = cellInfoArray.filter({$0.title.lowercased().prefix(searchText.count) == searchText.lowercased()})
        printSearchResults()
        searching = true
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searching = false
        self.tableView.reloadData()
    }
}
