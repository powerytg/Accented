//
//  ReplyModel.swift
//  Accented
//
//  Created by You, Tiangong on 8/19/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReplyModel: NSObject {
    private var dateFormatter = NSDateFormatter()
    
    var replyId : String
    var parentId : String
    var userId : String
    var body : String
    var creationDate : NSDate?
    var user : UserModel
    
    init(json:JSON) {
        replyId = json["id"].string!
        parentId = json["parent_id"].string!
        userId = json["user_id"].string!
        body = json["body"].string!

        // Dates
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZZ"
        let createdAt = json["created_at"].string!
        creationDate = dateFormatter.dateFromString(createdAt)
        
        // User
        user = UserModel(json: json["user"])
    }

}
