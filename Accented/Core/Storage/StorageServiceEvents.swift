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
    static let streamDidUpdate = Notification.Name("streamDidUpdate")
    
    // Comments retrieved for photo
    static let photoCommentsDidUpdate = Notification.Name("photoCommentsDidUpdate")

    // Comments posted for photo
    static let didPostComment = Notification.Name("didPostComment")

    // User search result updated
    static let userSearchResultDidUpdate = Notification.Name("userSearchResultDidUpdate")
    
    // MARK: - Parameters
    
    // Stream type
    static let streamType = "streamType"
    
    // Page
    static let page = "page"
    
    // Stream id
    static let streamId = "streamId"
    
    // Photo id
    static let photoId = "photoId"
    
    // Photos
    static let photos = "photos"
    
    // Keyword
    static let keyword = "keyword"
}
