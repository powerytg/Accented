//
//  DrawerAnimationContext.swift
//  Accented
//
//  Created by Tiangong You on 6/16/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DrawerAnimationContext: NSObject {
    
    // Whether the transition is interactive
    var interactive = false
    
    // Weak reference to the host view controller
    weak var container : UIViewController?
    
    // Strong reference to the content view controller
    var content : UIViewController
    
    // Drawer size
    var drawerSize : CGSize = CGSizeZero
    
    // Anchor
    var anchor : DrawerAnchor = .Left
    
    // Presentation controller
    weak var presentationController : DrawerPresentationController?
    
    // Animation configurations
    var configurations = DrawerAnimationParams()
    
    required init(content : UIViewController) {
        self.content = content
        super.init()
    }
}
