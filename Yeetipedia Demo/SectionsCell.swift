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
        
        // remove HTML
//        var str = section?.info["content"] as! String
//        str = str.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
//        str = str.replacingOccurrences(of: "\\s{2,}", with: " ", options: .regularExpression)
        let htmlString = section?.info["content"] as! String
        let attributed = try! NSAttributedString(data: htmlString.data(using: .unicode)!, options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)


        content?.text = attributed.string
        title?.text = section?.info["heading"] as? String
        
        print(section?.info["content"] ?? "no")
    }
    
    
}
