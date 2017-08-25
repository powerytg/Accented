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
    static let streamSelectionWillChange = Notification.Name("streamSelectionWillChange")
    
    // Request of left drawer
    static let didRequestLeftDrawer = Notification.Name("didRequestLeftDrawer")
    
    // Request of right drawer
    static let didRequestRightDrawer = Notification.Name("didRequestRightDrawer")
    
    // Request of display style change
    static let didRequestChangeDisplayStyle = Notification.Name("didRequestChangeDisplayStyle")
    
    // MARK: Keys
    
    // Selected stream key
    static let selectedStreamType = "selectedStreamType"
    
}
