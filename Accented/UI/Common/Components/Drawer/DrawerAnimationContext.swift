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
    
    // Weak reference to the drawer view controller
    weak var drawer : DrawerViewController?
    
    // Weak reference to the content view controller
    weak var content : UIViewController?
    
    // Drawer size
    var drawerSize : CGSize = CGSizeZero
    
    // Anchor
    var anchor : DrawerAnchor = .Left
    
    // Animation configurations
    var configurations = DrawerAnimationParams()
}
