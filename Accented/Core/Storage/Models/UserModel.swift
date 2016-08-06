//
//  UserModel.swift
//  Accented
//
//  Created by Tiangong You on 8/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import SwiftyJSON

enum UserAvatar : String {
    case Large = "large"
    case Default = "default"
    case Small = "small"
    case Tiny = "tiny"
}

class UserModel: NSObject {
    var userId : String!
    var followersCount : Int = 0
    var coverUrl : String?
    var lastName : String?
    var firstName : String?
    var userName : String!
    var fullName : String?
    
    // Avatars
    var avatarUrls = [UserAvatar : String]()
    
    init(json : JSON) {
        super.init()
        
        self.userId = String(json["id"].int!)
        if let followCount = json["followers_count"].int {
            followersCount = followCount
        }
        
        self.coverUrl = json["cover_url"].string
        self.lastName = json["lastname"].string
        self.firstName = json["firstname"].string
        self.fullName = json["fullname"].string
        self.userName = json["username"].string!
        
        
        // Avatar urls
        if let largeAvatar = json["avatars"]["large"]["https"].string {
            avatarUrls[.Large] = largeAvatar
        }

        if let defaultAvatar = json["avatars"]["default"]["https"].string {
            avatarUrls[.Default] = defaultAvatar
        }

        if let smallAvatar = json["avatars"]["small"]["https"].string {
            avatarUrls[.Small] = smallAvatar
        }

        if let tinyAvatar = json["avatars"]["tiny"]["https"].string {
            avatarUrls[.Tiny] = tinyAvatar
        }
    }
}
