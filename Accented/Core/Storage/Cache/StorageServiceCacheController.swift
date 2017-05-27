//
//  StorageServiceCacheController.swift
//  Accented
//
//  Cache controller for StorageService
//
//  Created by Tiangong You on 5/23/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class StorageServiceCacheController: NSObject {
    // Stream cache
    let streamCache = NSCache<NSString, StreamModel>()
    
    // User cache
    let userCache = NSCache<NSString, UserModel>()
    
    // Comments cache
    let commentsCache = NSCache<NSString, CommentCollectionModel>()
    
    // Photo search result cache
    let photoSearchResultCache = NSCache<NSString, PhotoSearchStreamModel>()
    
    // User search result cache
    let userSearchResultCache = NSCache<NSString, UserSearchResultModel>()
    
    // Get a cached object. If the object is not cached then create a new one and put it into the cache
    func getCachedResource<T : NSCopying>(cacheKey : String,
                           inCache cache : NSCache<NSString, T>,
                           creationCallback : (() -> T)) -> T {
        if let stream = cache.object(forKey: NSString(string: cacheKey)) {
            return stream.copy() as! T
        } else {
            let stream = creationCallback()
            cache.setObject(stream, forKey: NSString(string: cacheKey))
            return stream
        }
    }
}