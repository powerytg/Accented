//
//  CommentCollectionModel.swift
//  Accented
//
//  Collection model that represents a specific photo's comments and replies
//
//  Created by Tiangong You on 5/23/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class CommentCollectionModel: CollectionModel<CommentModel> {
    // Parent photo id
    var photoId : String
    
    init(photoId : String) {
        self.photoId = photoId
        super.init()
        
        // Generate an uuid
        self.modelId = photoId
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let clone = CommentCollectionModel(photoId : photoId)
        clone.totalCount = self.totalCount
        clone.items = items        
        return clone
    }
}
