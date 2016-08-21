//
//  CommentModel.swift
//  Accented
//
//  Created by Tiangong You on 8/8/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import SwiftyJSON

class CommentModel: NSObject {
    private var dateFormatter = NSDateFormatter()
    
    var commentId : String
    var userId : String
    var commentedOnUserId : String
    var body : String
    var creationDate : NSDate?
    var user : UserModel
    var replies : [ReplyModel]
    
    init(json:JSON) {
        commentId = String(json["id"].int!)
        commentedOnUserId = String(json["to_whom_user_id"].int!)
        userId = String(json["user_id"].int!)
        body = json["body"].string!
        
        // Dates
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZZ"
        let createdAt = json["created_at"].string!
        creationDate = dateFormatter.dateFromString(createdAt)
        
        // User
        user = UserModel(json: json["user"])
        
        // Replies
        replies = []
        // Image urls
        for (_, replyJSON):(String, JSON) in json["replies"] {
            let reply = ReplyModel(json: replyJSON)
            replies.append(reply)
        }

    }

}
