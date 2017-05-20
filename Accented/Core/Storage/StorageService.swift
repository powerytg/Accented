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
    fileprivate override init() {
        super.init()
        
        initializeEventListeners()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Stream cache
    let streamCache = NSCache<NSString, StreamModel>()
    
    // Currently selected stream
    var currentStream : StreamModel = StreamModel(streamType: .Popular)
    
    // Photo cache
    let photoCache = NSCache<NSString, PhotoModel>()
    
    // Initialize event listeners to monitor APIService results
    fileprivate func initializeEventListeners() {
        let notificationCenter = NotificationCenter.default
        
        // Photos returned for a stream
        notificationCenter.addObserver(self, selector: #selector(streamPhotosDidReturn(_:)), name: APIEvents.streamPhotosDidReturn, object: nil)
        
        // Photo comments returned
        notificationCenter.addObserver(self, selector: #selector(photoCommentsDidReturn(_:)), name: APIEvents.commentsDidReturn, object: nil)
        
        // Photo comment posted
        notificationCenter.addObserver(self, selector: #selector(didPostComment(_:)), name: APIEvents.commentDidPost, object: nil)

    }
}
