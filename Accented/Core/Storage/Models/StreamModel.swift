//
//  StreamModel.swift
//  Accented
//
//  Created by You, Tiangong on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamModel: NSObject {
    let streamType : StreamType
    var photos : Array<PhotoModel> = []
    
    // If nil, then the stream has not been loaded yet
    var totalCount : Int?
    
    // Has the stream been loaded
    var loaded : Bool {
        return totalCount != nil
    }
    
    required init(streamType : StreamType) {
        self.streamType = streamType
    }
    
    
}
