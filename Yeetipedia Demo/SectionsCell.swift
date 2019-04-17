//
//  SectionsCell.swift
//  Yeetipedia Demo
//
//  Created by Adam T. Cuellar on 3/20/19.
//  Copyright © 2019 Adam T. Cuellar. All rights reserved.
//

import UIKit

class SectionsCell: UITableViewCell {

    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var section: Section?
    {
        didSet
        {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        content?.text = section?.info["content"] as? String
        title?.text = section?.info["heading"] as? String
        
        print(section?.info["content"] ?? "no")
    }
    
    
}
