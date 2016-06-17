//
//  DrawerAnimationParams.swift
//  Accented
//
//  Created by You, Tiangong on 6/16/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

enum DrawerAnchor {
    case Left
    case Right
    case Bottom
}

class DrawerAnimationParams: NSObject {
    
    // Background curtain alpha
    var curtainAlpha : CGFloat = 0.8
    
    // Tolerance distance before the swipe gesture can trigger the drawer transition
    var openTriggeringTranslation : CGFloat = 20
    
    // If exceeding this velocity, the menu will always open regardless of traveling distance
    var openTriggeringVelocity : CGFloat = 50
    
    // If the travel diretion is on the opposite, the transition will be canceled if exceeding this threshold
    var cancelTriggeringTranslation : CGFloat = 20
}
