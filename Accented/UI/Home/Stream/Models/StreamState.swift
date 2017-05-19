//
//  StreamState.swift
//  Accented
//
//  Created by Tiangong You on 5/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamState: NSObject {
    
    // Whether the stream is refreshing
    var refreshing : Bool = false
    
    // Whether the stream is scrolling
    var scrolling : Bool = false
    
    // Whether the stream is loading its content
    var loading : Bool = false
}
