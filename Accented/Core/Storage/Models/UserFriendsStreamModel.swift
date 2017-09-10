//
//  UserFriendsStreamModel.swift
//  Accented
//
//  Model representing photos from a user's friends
//
//  Created by Tiangong You on 9/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserFriendsStreamModel: StreamModel {
    var userId : String
    
    override var streamId: String {
        return userId
    }
    
    init(userId : String) {
        self.userId = userId
        super.init(streamType: .User)
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let clone = UserFriendsStreamModel(userId : userId)
        clone.totalCount = self.totalCount
        clone.items = items
        return clone
    }
}

