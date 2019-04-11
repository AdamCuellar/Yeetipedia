//
//  TestingTable.swift
//  Yeetipedia Demo
//
//  Created by Boyce Estes on 3/31/19.
//  Copyright © 2019 Adam T. Cuellar. All rights reserved.
//

import UIKit

struct CellInfo {
    let id: Int
    let title: String
    let description: String
}

class CustomTocCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
}

class TestingTable: UITableViewController {

    var cellInfoArray = [CellInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this is used to set the dynamic height and remove the lines between rows
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        // tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellInfoArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TocIdentifier", for: indexPath) as! CustomTocCell

        let cellInfo = cellInfoArray[indexPath.row]
        
        cell.title.text = cellInfo.title
        cell.author.text = cellInfo.description
    
        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get the page ID of the selected row
        
        
    }
/*
     format of the incoming json:
     
     "pages":
        [
     [{"id": 1}, {"title":"test"}, {"description":"This test content has been edited via EditTestSections.php"}],
     [{"id": 2}, {"title":"abc"}, {}],
     [{"id": 3}, {"title":"Proposal for a perpetual motion machine"}, {}]
        ]
     String : [[String : Any]]
*/


}
