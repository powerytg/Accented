//
//  CommentModel.swift
//  Accented
//
//  Comment model for a photo
//
//  Created by Tiangong You on 8/8/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import SwiftyJSON

class CommentModel: ModelBase {
    var dateFormatter = DateFormatter()    
    var commentId : String!
    var userId : String!
    var commentedOnUserId : String!
    var body : String!
    var creationDate : Date?
    var user : UserModel!
    
    override init() {
        super.init()
    }
    
    init(json:JSON) {
        super.init()
        commentId = String(json["id"].int!)
        modelId = commentId
        commentedOnUserId = String(json["to_whom_user_id"].int!)
        userId = String(json["user_id"].int!)
        body = json["body"].string!.trimmingCharacters(in: .whitespaces)
        
        // Dates
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZZ"
        let createdAt = json["created_at"].string!
        creationDate = dateFormatter.date(from: createdAt)
        
        // User
        user = UserModel(json: json["user"])
    }

    override func copy(with zone: NSZone? = nil) -> Any {
        let clone = CommentModel()
        clone.commentId = self.commentId
        clone.modelId = self.modelId
        clone.commentedOnUserId = self.commentedOnUserId
        clone.userId = self.userId
        clone.creationDate = self.creationDate
        clone.user = self.user.copy() as! UserModel
        return clone
    }
}
