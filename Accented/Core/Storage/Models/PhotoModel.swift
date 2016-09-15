//
//  PhotoModel.swift
//  Accented
//
//  Created by You, Tiangong on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import SwiftyJSON

class PhotoModel: NSObject {
    fileprivate var dateFormatter = DateFormatter()
    
    var photoId : String
    var imageUrls = [ImageSize : String!]()
    var width : CGFloat
    var height: CGFloat
    var title : String
    var desc : String?
    var creationDate : Date?
    var lens : String?
    var camera : String?
    var aperture : String?
    var longitude : Double?
    var latitude : Double?
    var tags = [String]()
    var user : UserModel
    
    var comments = [CommentModel]()
    var commentsCount : Int?
    
    init(json:JSON) {
        photoId = String(json["id"].int!)
        
        // Image urls
        for (_, imageJson):(String, JSON) in json["images"] {
            // Parse size metadta
            let imageSizeString = String(imageJson["size"].int!)
            let size = ImageSize(rawValue: imageSizeString)
            imageUrls[size!] = imageJson["https_url"].string!
        }
        
        // Original width and height
        width = CGFloat(json["width"].int!)
        height = CGFloat(json["height"].int!)
        
        // Title
        title = json["name"].string!
        
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
        
        // Tags
        for (_, tagJSON):(String, JSON) in json["tags"] {
            tags.append(tagJSON.string!)
        }
    }
}
