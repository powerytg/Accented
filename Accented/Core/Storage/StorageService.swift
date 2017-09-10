//
//  StorageService.swift
//  Accented
//
//  Created by You, Tiangong on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StorageService: NSObject {
    
    // Default page size
    static let pageSize = 20
    
    // Parser processing GCD queue
    let parsingQueue = DispatchQueue(label: "com.accented.parser", attributes: [])
    
    // Singleton instance
    static let sharedInstance = StorageService()
    private override init() {
        super.init()
        
        initializeEventListeners()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // Current user
    var currentUser : UserModel?
    
    // Cache controller
    var cacheController = StorageServiceCacheController()

    // Currently selected stream
    var currentStream : StreamModel = StreamModel(streamType: .Popular)
    
    // Currently selected sorting option for photo search, default to "currently most popular"
    var currentPhotoSearchSortingOption : PhotoSearchSortingOptions = .highestRating
    
    // Initialize event listeners to monitor APIService results
    private func initializeEventListeners() {
        let notificationCenter = NotificationCenter.default
        
        // Photos returned for a stream
        notificationCenter.addObserver(self, selector: #selector(streamPhotosDidReturn(_:)), name: APIEvents.streamPhotosDidReturn, object: nil)
        
        // Photo comments returned
        notificationCenter.addObserver(self, selector: #selector(photoCommentsDidReturn(_:)), name: APIEvents.commentsDidReturn, object: nil)
        
        // Photo comment posted
        notificationCenter.addObserver(self, selector: #selector(didPostComment(_:)), name: APIEvents.commentDidPost, object: nil)

        // User search returned
        notificationCenter.addObserver(self, selector: #selector(userSearchDidReturn(_:)), name: APIEvents.userSearchResultDidReturn, object: nil)
        
        // User profile returned
        notificationCenter.addObserver(self, selector: #selector(userProfileDidReturn(_:)), name: APIEvents.userProfileDidReturn, object: nil)
        
        // User followers returned
        notificationCenter.addObserver(self, selector: #selector(userFollowersDidReturn(_:)), name: APIEvents.userFollowersDidReturn, object: nil)

        // User friends returned
        notificationCenter.addObserver(self, selector: #selector(userFriendsDidReturn(_:)), name: APIEvents.userFriendsDidReturn, object: nil)

        // User gallery list returned
        notificationCenter.addObserver(self, selector: #selector(galleryListDidReturn(_:)), name: APIEvents.userGalleriesDidReturn, object: nil)
    }
    
    func signout() {
        currentUser = nil
        currentStream = StreamModel(streamType: .Popular)
        currentPhotoSearchSortingOption = .highestRating
        cacheController = StorageServiceCacheController()
    }
}
