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
    
    required init(streamType : StreamType) {
        self.streamType = streamType
    }
}
