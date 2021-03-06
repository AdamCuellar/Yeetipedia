//
//  TestingTable.swift
//  Yeetipedia Demo
//
//  Created by Boyce Estes on 3/31/19.
//  Copyright © 2019 Adam T. Cuellar. All rights reserved.
//

import UIKit

//struct CellInfo {
//    let id: Int
//    let title: String
//    let description: String
//}

class CustomTocCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
}

class TestingTable: UITableViewController {

    // information for the table of contents page
    var cellInfoArray = [CellInfo]()
    var searchResults = [CellInfo]()
    
    var searchBar : UISearchBar = UISearchBar()
    var searching : Bool = false
    
    // information for the page that is clicked on in the table of contents
    var pageInfo = [[String:Any]]()
    var cellTitle = String()
    var clicked = Bool()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerView: UIView = UIView.init(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 100, height: 100)))
        headerView.backgroundColor = UIColor(red: 255.0/255.0, green: 15.0/255.0, blue: 15.0/255.0, alpha: 1.0)
        
//        let searchBar: UISearchBar = UISearchBar.init(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.screendWidth, height: 100)))
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        //navigationItem.titleView = searchBar
        // labelView.text = "hello"
        
        headerView.addSubview(searchBar)
        self.tableView.tableHeaderView = headerView

        
        // this is used to set the dynamic height and remove the lines between rows
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        //tableView.rowHeight = 100
        // tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        // add button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TestingTable.logoutTapped(_:)))
    }

    
    @objc func logoutTapped(_ sender:UIBarButtonItem!) {
        print("logout tapped")
        DispatchQueue.main.async {
                // self.performSegue(withIdentifier: "go_to_table_of_contents", sender: nil)
                self.performSegue(withIdentifier:"go_to_login", sender:nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        clicked = false
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellInfoArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TocIdentifier", for: indexPath) as! CustomTocCell
        print("\(indexPath.row)) hello there world")
        let cellInfo = cellInfoArray[indexPath.row]
        
        cell.title.text = cellInfo.title
        cell.author.text = cellInfo.description
    
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
                        self.performSegue(withIdentifier:"push_specific_page", sender:nil)
                }
            }
        }
    }
    
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

                let sections = json["sections"] as? [[String:Any]]
                print("print 2d array: \(String(describing: sections))")
                // print(json)
                
                DispatchQueue.main.async {
                    self.pageInfo = sections!
                    self.cellTitle = title
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "push_specific_page" {
            print("HELLO2")
            if let nextVC = segue.destination as? TableViewController {
                nextVC.pageInfo = pageInfo
                nextVC.cellTitle = cellTitle
            }
        }
    }
}

extension TestingTable : UISearchBarDelegate {
    private func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults = cellInfoArray.filter({$0.title.prefix(searchText.count) == searchText})
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
}
