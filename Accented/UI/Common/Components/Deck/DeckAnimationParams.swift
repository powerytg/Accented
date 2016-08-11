//
//  DeckAnimationParams.swift
//  Accented
//
//  Created by Tiangong You on 8/10/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DeckAnimationParams: NSObject {
    
    // Tolerance distance before the swipe gesture can trigger the scroll transition
    var scrollTriggeringTranslation : CGFloat = 60
    
    // If exceeding this velocity, the deck will scroll regardless of traveling distance
    var scrollTriggeringVelocity : CGFloat = 100
    
    // If the travel diretion is on the opposite, the transition will be canceled if exceeding this threshold
    var cancelTriggeringTranslation : CGFloat = 30
}
