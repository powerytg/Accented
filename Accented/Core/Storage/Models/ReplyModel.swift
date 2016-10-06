//
//  ReplyModel.swift
//  Accented
//
//  Created by You, Tiangong on 8/19/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import SwiftyJSON

struct ReplyModel {
    fileprivate var dateFormatter = DateFormatter()
    
    var replyId : String
    var parentId : String
    var userId : String
    var body : String
    var creationDate : Date?
    var user : UserModel
    
    init(json:JSON) {
        replyId = String(json["id"].int!)
        parentId = String(json["parent_id"].int!)
        userId = String(json["user_id"].int!)
        body = json["body"].string!

        // Dates
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZZ"
        let createdAt = json["created_at"].string!
        creationDate = dateFormatter.date(from: createdAt)
        
        // User
        user = UserModel(json: json["user"])
    }

}
