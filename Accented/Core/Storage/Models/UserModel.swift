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

enum UpgradeStatus : Int {
    case Basic = 0
    case Plus = 1
    case Awesome = 2
}

class UserModel: ModelBase {
    var dateFormatter = DateFormatter()
    var userId : String!
    var followersCount : Int?
    var coverUrl : String?
    var lastName : String?
    var firstName : String?
    var userName : String!
    var fullName : String?
    var city : String?
    var country : String?
    var userPhotoUrl : String?
    var about : String?
    var registrationDate : Date?
    var contacts : [String : String]?
    var equipments : [String : [String]]?
    var photoCount : Int?
    var following : Bool?
    var friendCount : Int?
    var domain : String?
    var upgradeStatus : UpgradeStatus!
    
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
        
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZZ"
        self.about = json["about"].string
        if let regDate = json["registration_date"].string {
            self.registrationDate = dateFormatter.date(from: regDate)
        }
        
        if let _ = json["contacts"].dictionary {
            self.contacts = [String : String]()
            for (key, value) : (String, JSON) in json["contacts"] {
                self.contacts![key] = value.stringValue
            }
        }
        
        if let _ = json["equipments"].dictionary {
            self.equipments = [String : [String]]()
            for (type, _) : (String, JSON) in json["equipments"] {
                self.equipments![type] = []
                for (_, gear) in json["equipments"][type] {
                    self.equipments![type]!.append(gear.stringValue)
                }
            }
        }
        
        self.photoCount = json["photos_count"].int
        self.following = json["following"].bool
        self.friendCount = json["friends_count"].int
        self.domain = json["domain"].string
        self.upgradeStatus = UpgradeStatus(rawValue: json["upgrade_status"].intValue)
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
        clone.about = self.about
        clone.registrationDate = self.registrationDate
        clone.contacts = self.contacts
        clone.equipments = self.equipments
        clone.photoCount = self.photoCount
        clone.following = self.following
        clone.friendCount = self.friendCount
        clone.domain = self.domain
        clone.upgradeStatus = self.upgradeStatus
        
        return clone
    }
}
