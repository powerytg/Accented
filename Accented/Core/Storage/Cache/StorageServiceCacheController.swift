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
    
    // User profile cache
    let userProfileCache = NSCache<NSString, UserModel>()
    
    // User followers cache
    let userFollowersCache = NSCache<NSString, UserFollowersModel>()

    // User friends cache
    let userFriendsCache = NSCache<NSString, UserFriendsModel>()

    // User photos cache
    let userPhotoCache = NSCache<NSString, UserStreamModel>()

    // User galleries cache
    let userGalleryCache = NSCache<NSString, GalleryCollectionModel>()

    // User gallery photo cache
    let galleryPhotoCache = NSCache<NSString, GalleryStreamModel>()
    
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
    
    func clearAll() {
        streamCache.removeAllObjects()
        userCache.removeAllObjects()
        commentsCache.removeAllObjects()
        photoSearchResultCache.removeAllObjects()
        userSearchResultCache.removeAllObjects()
        userProfileCache.removeAllObjects()
        userFollowersCache.removeAllObjects()
        userFriendsCache.removeAllObjects()
        userPhotoCache.removeAllObjects()
        userGalleryCache.removeAllObjects()
        galleryPhotoCache.removeAllObjects()
    }
}
