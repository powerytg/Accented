//
//  StreamModel.swift
//  Accented
//
//  Generic stream data model
//
//  Created by You, Tiangong on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamModel : CollectionModel<PhotoModel> {
    let streamType : StreamType

    // Dynamically generated stream identifier
    var streamId : String {
        return streamType.rawValue
    }
    
    init(streamType : StreamType) {
        self.streamType = streamType
        super.init()
        self.modelId = self.streamId
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let clone = StreamModel(streamType: self.streamType)
        clone.totalCount = self.totalCount
        clone.items = items        
        return clone
    }
}
