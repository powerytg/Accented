//
//  GalleryCollectionModel.swift
//  Accented
//
//  List of galleries
//
//  Created by You, Tiangong on 6/2/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class GalleryCollectionModel: CollectionModel<GalleryModel> {
    // Parent user id
    var userId : String
    
    init(userId : String) {
        self.userId = userId
        super.init()
        self.modelId = userId
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let clone = GalleryCollectionModel(userId : userId)
        clone.totalCount = self.totalCount
        clone.items = items
        return clone
    }
}
