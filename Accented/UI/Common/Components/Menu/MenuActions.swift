//
//  MenuActions.swift
//  Accented
//
//  List of all menu actions
//
//  Created by Tiangong You on 9/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

enum MenuActions {
    // Unspecified
    case None
    
    // Home
    case About
    case SignIn
    case SignOut
    case PopularPhotos
    case FreshPhotos
    case UpcomingPhotos
    case EditorsChoice
    case PearlCam
    case Search
    case MyProfile
    case MyGalleries
    case MyPhotos
    case MyFriends
    case FriendsPhotos
    
    // Details
    case Home
    case Vote
    case ViewComments
    case ViewUserProfile
    case ViewInFullScreen
    case AddComment
    case ReportPhoto
    
    // User
    case Follow
    case ViewUserPhotos
    case ViewUserGalleries
    case ViewUserFriends
    case ViewAsList
    case ViewAsGroup
    
    // Report content
    case ReportOffensive
    case ReportSpam
    case ReportOfftopic
    case ReportCopyright
    case ReportWrongContent
    case ReportAdultContent
    case ReportOtherReason
}
