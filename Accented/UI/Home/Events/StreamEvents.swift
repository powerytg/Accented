//
//  StreamEvents.swift
//  Accented
//
//  Created by You, Tiangong on 5/8/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamEvents: NSObject {
    
    // MARK: Event names
    
    // Stream is about the change
    static let streamSelectionWillChange = "streamSelectionWillChange"
    
    // Request of left drawer
    static let didRequestLeftDrawer = "didRequestLeftDrawer"
    
    // Request of right drawer
    static let didRequestRightDrawer = "didRequestRightDrawer"
    
    // MARK: Keys
    
    // Selected stream key
    static let selectedStreamType = "selectedStreamType"
    
}
