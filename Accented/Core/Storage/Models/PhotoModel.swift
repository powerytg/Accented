//
//  PhotoModel.swift
//  Accented
//
//  Photo view model
//
//  Created by You, Tiangong on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import SwiftyJSON

class PhotoModel: ModelBase {
    private var dateFormatter = DateFormatter()
    
    var photoId : String!
    var imageUrls = [ImageSize : String!]()
    var width : CGFloat!
    var height: CGFloat!
    var title : String!
    var desc : String?
    var creationDate : Date?
    var lens : String?
    var camera : String?
    var aperture : String?
    var longitude : Double?
    var latitude : Double?
    var tags = [String]()
    var user : UserModel!
    var commentsCount : Int?
    var voted : Bool!
    var voteCount : Int?
    var rating : Float?
    var viewCount : Int?
    
    override init() {
        super.init()
    }
    
    init(json:JSON) {
        super.init()
        photoId = String(json["id"].int!)
        modelId = photoId
        
        // Image urls
        for (_, imageJson):(String, JSON) in json["images"] {
            guard imageJson["https_url"].string != nil else { continue }
            // Parse size metadta
            let imageSizeString = String(imageJson["size"].intValue)
            if let size = ImageSize(rawValue: imageSizeString) {
                imageUrls[size] = imageJson["https_url"].stringValue
            }
        }
        
        // Original width and height
        width = CGFloat(json["width"].intValue)
        height = CGFloat(json["height"].intValue)
        
        // Title
        title = json["name"].stringValue
        
        // Description
        desc = json["description"].string
        
        // Dates
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZZ"
        let createdAt = json["created_at"].string!
        creationDate = dateFormatter.date(from: createdAt)

        // EXIF
        camera = json["camera"].string
        lens = json["lens"].string
        aperture = json["aperture"].string
        
        // Geolocation
        longitude = json["longitude"].double
        latitude = json["latitude"].double
        
        // User
        user = UserModel(json: json["user"])
        StorageService.sharedInstance.putUserToCache(user)
        
        // Tags
        for (_, tagJSON):(String, JSON) in json["tags"] {
            tags.append(tagJSON.string!)
        }
        
        // Like status
        voted = json["voted"].boolValue
        voteCount = json["votes_count"].int
        rating = json["rating"].float
        viewCount = json["times_viewed"].int
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let clone = PhotoModel()
        clone.modelId = self.modelId
        clone.photoId = self.photoId
        clone.imageUrls = self.imageUrls
        clone.width = self.width
        clone.height = self.height
        clone.title = self.title
        clone.desc = self.desc
        clone.creationDate = self.creationDate
        clone.camera = self.camera
        clone.lens = self.lens
        clone.aperture = self.aperture
        clone.longitude = self.longitude
        clone.latitude = self.latitude
        clone.user = self.user.copy() as! UserModel
        clone.tags = self.tags
        clone.voted = self.voted
        clone.voteCount = self.voteCount
        clone.rating = self.rating
        clone.viewCount = self.viewCount
        return clone
    }
}
