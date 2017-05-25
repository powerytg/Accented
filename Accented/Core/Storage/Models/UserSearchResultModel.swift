//
//  UserSearchResultModel.swift
//  Accented
//
//  User search result psudo model
//
//  Created by Tiangong You on 5/22/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserSearchResultModel: CollectionModel<UserModel> {
    // Search term
    var keyword : String
    
    init(keyword : String) {
        self.keyword = keyword
        super.init()
        self.modelId = keyword
    }

    override func copy(with zone: NSZone? = nil) -> Any {
        let clone = UserSearchResultModel(keyword : keyword)
        clone.totalCount = self.totalCount
        clone.items = items
        return clone
    }
}
