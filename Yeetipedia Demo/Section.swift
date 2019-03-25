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
    var text: String
    
    init(info: [String:Any])
    {
        self.info = info
        self.title = (info["section_title"] as? String)!
        self.text = (info["section_text"] as? String)!
    }
}
