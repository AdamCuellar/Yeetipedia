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
    
    var heading : String
    var content : String
    var pic_loc : String
    var caption : String
    var rank : Int

    init(info: [String:Any])
    {
        self.info = info

        self.heading = (info["heading"] as? String)!
        self.content = (info["content"] as? String)!
        self.pic_loc = ""
        self.caption = ""
        
        //self.pic_loc = (info["pic_loc"] as? String)!
        //self.caption = (info["caption"] as? String)!
        self.rank = (info["rank"] as? Int)!
    }
}
