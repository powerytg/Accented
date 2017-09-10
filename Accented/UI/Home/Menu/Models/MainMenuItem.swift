//
//  MainMenuItem.swift
//  Accented
//
//  Created by Tiangong You on 9/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class MainMenuItem: MenuItem {
    var action : MainMenuActions
    
    init(action : MainMenuActions, text : String, image : UIImage? = nil) {
        self.action = action
        super.init(text, image: image)
    }
}
