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

    // User profile retrieved
    static let userProfileDidUpdate = Notification.Name("userProfileDidUpdate")

    // Current user profile retrieved
    static let currentUserProfileDidUpdate = Notification.Name("currentUserProfileDidUpdate")

    // Failed to retrieve current user profile
    static let currentUserProfileFailedUpdate = Notification.Name("currentUserProfileFailedUpdate")

    // User followers updated
    static let userFollowersDidUpdate = Notification.Name("userFollowersDidUpdate")

    // User friends updated
    static let userFriendsDidUpdate = Notification.Name("userFriendsDidUpdate")

    // User gallery list updated
    static let userGalleryListDidUpdate = Notification.Name("userGalleryListDidUpdate")

    // Photo did update
    static let photoVoteDidUpdate = Notification.Name("photoVoteDidUpdate")
    
    // MARK: - Parameters
    
    // Stream type
    static let streamType = "streamType"
    
    // Page
    static let page = "page"
    
    // Stream id
    static let streamId = "streamId"
    
    // Photo id
    static let photoId = "photoId"
    
    // User id
    static let userId = "userId"
    
    // Photos
    static let photos = "photos"

    // Galleries
    static let galleries = "galleries"

    // Keyword
    static let keyword = "keyword"
    
    // Photo
    static let photo = "photo"
    
    // Sort
    static let sort = "sort"
}
