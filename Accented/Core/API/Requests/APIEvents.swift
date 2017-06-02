//
//  APIEvents.swift
//  Accented
//
//  Created by You, Tiangong on 9/16/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class APIEvents: NSObject {

    // Stream photos retrieved
    static let streamPhotosDidReturn = Notification.Name("streamPhotosDidReturn")
    
    // Failed to load stream photos
    static let streamPhotosFailedReturn = Notification.Name("streamPhotosFailedReturn")

    // Photo comments retrieved
    static let commentsDidReturn = Notification.Name("commentsDidReturn")

    // Failed to load photo comments
    static let commentsFailedReturn = Notification.Name("commentsFailedReturn")

    // Added a comment
    static let commentDidPost = Notification.Name("commentDidPost")
    
    // Failed to add a comment
    static let commentFailedPost = Notification.Name("commentFailedPost")

    // User search result retrieved
    static let userSearchResultDidReturn = Notification.Name("userSearchResultDidReturn")
    
    // Failed to load user search results
    static let userSearchResultFailedReturn = Notification.Name("userSearchResultFailedReturn")

    // User profile retrieved
    static let userProfileDidReturn = Notification.Name("userProfileDidReturn")
    
    // Failed to load user profile
    static let userProfileFailedReturn = Notification.Name("userProfileFailedReturn")

    // User followers retrieved
    static let userFollowersDidReturn = Notification.Name("userFollowersDidReturn")
    
    // Failed to load user followers
    static let userFollowersFailedReturn = Notification.Name("userFollowersFailedReturn")

    // User galleries retrieved
    static let userGalleriesDidReturn = Notification.Name("userGalleriesDidReturn")
    
    // Failed to load user galleries
    static let userGalleriesFailedReturn = Notification.Name("userGalleriesFailedReturn")

}
