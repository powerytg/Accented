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
    let parsingQueue = dispatch_queue_create("com.accented.parser", nil)
    
    // Singleton instance
    static let sharedInstance = StorageService()
    private override init() {
        super.init()
        
        initializeEventListeners()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // Stream cache
    let streamCache = NSCache()
    
    // Currently selected stream
    var currentStream : StreamModel = StreamModel(streamType: .Popular)
    
    // Photo cache
    let photoCache = NSCache()
    
    // Initialize event listeners to monitor APIService results
    private func initializeEventListeners() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        // Photos returned for a stream
        notificationCenter.addObserver(self, selector: #selector(streamPhotosDidReturn(_:)), name: "streamPhotosDidReturn", object: nil)
        
        // Photo comments returned
        notificationCenter.addObserver(self, selector: #selector(photoCommentsDidReturn(_:)), name: "commentsDidReturn", object: nil)
    }
}
