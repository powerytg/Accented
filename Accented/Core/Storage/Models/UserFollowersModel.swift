//
//  UserFollowersModel.swift
//  Accented
//
//  Model that represents a user's followers
//
//  Created by Tiangong You on 5/30/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserFollowersModel: CollectionModel<UserModel> {
    // User id
    var userId : String
    
    init(userId : String) {
        self.userId = userId
        super.init()
        
        self.modelId = userId
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let clone = UserFollowersModel(userId : userId)
        clone.totalCount = self.totalCount
        clone.items = items
        return clone
    }
}
