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

    // Failed to retrieve user profile
    static let userProfileFailedReturn = Notification.Name("userProfileFailedReturn")

    // Current user profile retrieved
    static let currentUserProfileDidReturn = Notification.Name("currentUserProfileDidReturn")

    // Failed to load current user profile
    static let currentUserProfileFailedReturn = Notification.Name("currentUserProfileFailedReturn")

    // User followers retrieved
    static let userFollowersDidReturn = Notification.Name("userFollowersDidReturn")
    
    // Failed to load user followers
    static let userFollowersFailedReturn = Notification.Name("userFollowersFailedReturn")

    // User friends retrieved
    static let userFriendsDidReturn = Notification.Name("userFriendsDidReturn")
    
    // Failed to load user friends
    static let userFriendsFailedReturn = Notification.Name("userFriendsFailedReturn")

    // User galleries retrieved
    static let userGalleriesDidReturn = Notification.Name("userGalleriesDidReturn")
    
    // Failed to load user galleries
    static let userGalleriesFailedReturn = Notification.Name("userGalleriesFailedReturn")

    // Photo successfully uploaded
    static let photoDidUpload = Notification.Name("photoDidUpload")
    
    // Photo failed to upload
    static let photoFailedUpload = Notification.Name("photoFailedUpload")
    
    // Vote photo did succeed
    static let photoDidVote = Notification.Name("photoDidVote")
    
    // Vote photo did fail
    static let photoFailedVote = Notification.Name("photoFailedVote")

    // Delete vote did succeed
    static let photoDidDeleteVote = Notification.Name("photoDidDeleteVote")
    
    // Delete vote did fail
    static let photoFailedDeleteVote = Notification.Name("photoFailedDeleteVote")
    
    // Added user to followers list
    static let didFollowUser = Notification.Name("didFollowUser")

    // Failed to add user to followers list
    static let failedFollowUser = Notification.Name("failedFollowUser")

    // Removed user from followers list
    static let didUnfollowUser = Notification.Name("didUnfollowUser")
    
    // Failed to remove user from followers list
    static let failedUnfollowUser = Notification.Name("failedUnfollowUser")

    // Successfully reported a photo
    static let didReportPhoto = Notification.Name("didReportPhoto")
    
    // Failed to report a photo
    static let failedReportPhoto = Notification.Name("failedReportPhoto")

}
