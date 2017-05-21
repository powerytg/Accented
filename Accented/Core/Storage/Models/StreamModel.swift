//
//  StreamModel.swift
//  Accented
//
//  Stream data model
//
//  Created by You, Tiangong on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamModel: ModelBase {
    let streamType : StreamType
    var photos = [PhotoModel]()
    
    // If nil, then the stream has not been loaded yet
    var totalCount : Int?
    
    // Whether the stream been loaded
    var loaded : Bool {
        return totalCount != nil
    }
    
    required init(streamType : StreamType) {
        self.streamType = streamType
        super.init()
    }

    override func copy(with zone: NSZone? = nil) -> Any {
        let clone = StreamModel(streamType: self.streamType)
        StorageService.sharedInstance.synchronized(self) {
            clone.totalCount = self.totalCount
            clone.photos = photos
        }
        
        return clone
    }
}
