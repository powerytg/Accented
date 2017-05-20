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

}
