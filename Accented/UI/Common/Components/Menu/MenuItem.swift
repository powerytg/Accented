//
//  MenuItem.swift
//  Accented
//
//  Created by You, Tiangong on 8/24/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class MenuItem: NSObject {
    var text : String
    var image : UIImage?
    
    init(_ text : String, image : UIImage? = nil) {
        self.text = text
        self.image = image
        super.init()
    }
}
