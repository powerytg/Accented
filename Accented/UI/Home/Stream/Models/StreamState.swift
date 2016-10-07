//
//  StreamState.swift
//  Accented
//
//  Created by Tiangong You on 5/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamState: NSObject {
    
    // Whether the stream is scrolling
    var scrolling : Bool = false
    
    // If dirty, the stream will delay updating its content until it's no longer in scrolling state
    var dirty : Bool = false
    
    // Whether the stream is loading its content
    var loading : Bool = false
}
