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
    var dateFormatter = NSDateFormatter()
    
    var imageUrls : [ImageSize : String!]
    var width : CGFloat
    var height: CGFloat
    var title : String
    var desc : String?
    var creationDate : NSDate?
    
    var firstName : String
    
    init(json:JSON) {
        // Image urls
        imageUrls = [:]
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
        
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        let createdAt = json["created_at"].string!
        creationDate = dateFormatter.dateFromString(createdAt)
        
        // User
        if let firstNameString = json["user"]["firstname"].string {
            firstName = firstNameString
        } else {
            firstName = ""
        }
        
    }
}
