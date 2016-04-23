//
//  StorageService.swift
//  Accented
//
//  Created by You, Tiangong on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StorageService: NSObject {
    
    let pageSize = 20
    
    let parsingQueue = dispatch_queue_create("com.accented.parser", nil)
    
    // Singleton instance
    static let sharedInstance = StorageService()
    private override init() {
        super.init()
        
        initializeEventListeners()
    }

    // Streams
    let streamCache = NSCache()
    
    private func initializeEventListeners() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(streamPhotosDidReturn(_:)), name: "streamPhotosDidReturn", object: nil)
    }
}
