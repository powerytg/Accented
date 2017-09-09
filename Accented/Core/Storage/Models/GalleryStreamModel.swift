//
//  GalleryStreamModel.swift
//  Accented
//
//  Gallery photo stream model
//
//  Created by Tiangong You on 9/8/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class GalleryStreamModel: StreamModel {
    var userId : String
    var galleryId : String
    
    override var streamId: String {
        return "\(userId)_\(galleryId)"
    }
    
    init(userId : String, galleryId : String) {
        self.userId = userId
        self.galleryId = galleryId
        super.init(streamType: .Gallery)
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let clone = GalleryStreamModel(userId : userId, galleryId : galleryId)
        clone.totalCount = self.totalCount
        clone.items = items
        return clone
    }
}
