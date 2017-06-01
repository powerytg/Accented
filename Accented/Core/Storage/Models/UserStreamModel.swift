//
//  UserStreamModel.swift
//  Accented
//
//  User photo stream model
//
//  Created by Tiangong You on 5/31/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserStreamModel: StreamModel {
    var userId : String
    
    override var streamId: String {
        return userId
    }
    
    init(userId : String) {
        self.userId = userId
        super.init(streamType: .User)
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let clone = UserStreamModel(userId : userId)
        clone.totalCount = self.totalCount
        clone.items = items
        return clone
    }
}
