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
    var imageUrls : [ImageSize : String!]
    var width : CGFloat
    var height: CGFloat
    
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
    }
}