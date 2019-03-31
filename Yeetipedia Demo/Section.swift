//
//  Section.swift
//  Yeetipedia Demo
//
//  Created by Adam T. Cuellar on 3/20/19.
//  Copyright © 2019 Adam T. Cuellar. All rights reserved.
//

import UIKit

class Section
{
    var info: [String:Any]
    var title: String
    var author: String
    
    init(info: [String:Any])
    {
        self.info = info
        self.title = (info["page_title"] as? String)!
        self.author = (info["page_author"] as? String)!
    }
}
