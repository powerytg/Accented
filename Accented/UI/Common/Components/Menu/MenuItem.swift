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
    var action : MenuActions
    
    init(action : MenuActions, text : String, image : UIImage? = nil) {
        self.action = action
        self.text = text
        self.image = image
        super.init()
    }
}
