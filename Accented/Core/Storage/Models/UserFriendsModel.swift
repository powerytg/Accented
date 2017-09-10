//
//  UserFriendsModel.swift
//  Accented
//
//  User's following list
//
//  Created by Tiangong You on 9/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserFriendsModel: CollectionModel<UserModel> {
    // User id
    var userId : String
    
    init(userId : String) {
        self.userId = userId
        super.init()
        
        self.modelId = userId
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let clone = UserFriendsModel(userId : userId)
        clone.totalCount = self.totalCount
        clone.items = items
        return clone
    }
}
