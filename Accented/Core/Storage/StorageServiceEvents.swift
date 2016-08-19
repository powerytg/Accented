//
//  StorageServiceEvents.swift
//  Accented
//
//  Created by You, Tiangong on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StorageServiceEvents: NSObject {
    // MARK: - Events
    
    // Photos retrieved for stream
    static let streamDidUpdate = "streamDidUpdate"
    
    // Comments retrieved for photo
    static let photoCommentsDidUpdate = "photoCommentsDidUpdate"
    
    // MARK: - Parameters
    
    // Stream type
    static let streamType = "streamType"
    
    // Page
    static let page = "page"
    
    // Photo id
    static let photoId = "photoId"
}
