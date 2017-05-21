//
//  UserModel.swift
//  Accented
//
//  User model
//
//  Created by Tiangong You on 8/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import SwiftyJSON

// User avatar size definition
enum UserAvatar : String {
    case Large = "large"
    case Default = "default"
    case Small = "small"
    case Tiny = "tiny"
}

class UserModel: ModelBase {
    var userId : String!
    var followersCount : Int = 0
    var coverUrl : String?
    var lastName : String?
    var firstName : String?
    var userName : String!
    var fullName : String?
    var city : String?
    var country : String?
    var userPhotoUrl : String?
    
    // Avatars
    var avatarUrls = [UserAvatar : String]()
    
    override init() {
        super.init()
    }
    
    init(json : JSON) {
        super.init()
        
        self.userId = String(json["id"].int!)
        self.modelId = self.userId
        
        if let followCount = json["followers_count"].int {
            followersCount = followCount
        }
        
        self.coverUrl = json["cover_url"].string
        self.lastName = json["lastname"].string
        self.firstName = json["firstname"].string
        self.fullName = json["fullname"].string
        self.userName = json["username"].string!
        self.city = json["city"].string
        self.country = json["country"].string
        self.userPhotoUrl = json["userpic_url"].string
        
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
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let clone = UserModel()
        clone.userId = self.userId
        clone.modelId = self.modelId
        clone.followersCount = self.followersCount
        clone.coverUrl = self.coverUrl
        clone.lastName = self.lastName
        clone.firstName = self.firstName
        clone.fullName = self.fullName
        clone.userName = self.userName
        clone.city = self.city
        clone.country = self.country
        clone.userPhotoUrl = self.userPhotoUrl
        clone.avatarUrls = self.avatarUrls
        
        return clone
    }
}
