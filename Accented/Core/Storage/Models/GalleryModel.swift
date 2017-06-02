//
//  GalleryModel.swift
//  Accented
//
//  User gallery model
//
//  Created by You, Tiangong on 6/2/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import SwiftyJSON

class GalleryModel: ModelBase {
    
    var dateFormatter = DateFormatter()
    var galleryId : String!
    var desc : String?
    var subtitle : String?
    var name : String!
    var creationDate : Date!
    var coverPhotoUrl : String?
    var coverPhotoWidth : Int?
    var coverPhotoHeight : Int?
    var userId : String!
    var totalCount : Int!
    var lastUpdated : Date!
    var privacy : Bool!
    
    
    init(galleryId : String) {
        self.galleryId = galleryId
        super.init()
        self.modelId = self.galleryId
    }
    
    init(json : JSON) {
        super.init()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZZ"
        
        galleryId = json["id"].stringValue
        desc = json["description"].string
        subtitle = json["subtitle"].string
        creationDate = dateFormatter.date(from: json["created_at"].stringValue)
        lastUpdated = dateFormatter.date(from: json["updated_at"].stringValue)
        name = json["name"].stringValue
        
        if let coverPhotoArray = json["cover_photo"].array {
            if coverPhotoArray.count > 0 {
                let coverPhotoJson = coverPhotoArray[0]
                coverPhotoUrl = coverPhotoJson["url"].string
                coverPhotoWidth = coverPhotoJson["width"].int
                coverPhotoHeight = coverPhotoJson["height"].int
            }
        }
        
        totalCount = json["items_count"].intValue
        privacy = json["privacy"].boolValue
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let clone = GalleryModel(galleryId: self.galleryId)
        clone.modelId = self.modelId
        clone.totalCount = self.totalCount
        clone.desc = self.desc
        clone.subtitle = self.subtitle
        clone.name = self.name
        clone.creationDate = self.creationDate
        clone.coverPhotoUrl = self.coverPhotoUrl
        clone.coverPhotoWidth = self.coverPhotoWidth
        clone.coverPhotoHeight = self.coverPhotoHeight
        clone.userId = self.userId
        clone.lastUpdated = self.lastUpdated
        clone.privacy = self.privacy
        
        return clone
    }
}
