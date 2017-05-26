//
//  StorageService+Cache.swift
//  Accented
//
//  Created by You, Tiangong on 9/16/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

extension StorageService {
    // Retrieve a copy of the stream model
    func getStream(_ streamType : StreamType) -> StreamModel {
        return cacheController.getCachedResource(cacheKey: streamType.rawValue, inCache: cacheController.streamCache, creationCallback: { () -> StreamModel in
            return StreamModel(streamType: streamType)
        }) 
    }
    
    // Retrieve a copy of a photo's comments
    func getComments(_ photoId : String) -> CommentCollectionModel {
        return cacheController.getCachedResource(cacheKey: photoId, inCache: cacheController.commentsCache, creationCallback: { () -> CommentCollectionModel in
            return CommentCollectionModel(photoId : photoId)
        })
    }
    
    // Retrieve a copy of the specific photo search result stream with keyword
    func getPhotoSearchResult(keyword : String, sort : PhotoSearchSortingOptions) -> PhotoSearchStreamModel {
        let cacheKey = PhotoSearchStreamModel.streamIdWithKeyword(keyword: keyword, sort: sort)
        return cacheController.getCachedResource(cacheKey: cacheKey, inCache: cacheController.photoSearchResultCache, creationCallback: { () -> PhotoSearchStreamModel in
            return PhotoSearchStreamModel(keyword: keyword, sort : sort)
        })
    }
    
    // Retrieve a copy of the specific photo search result stream with tag
    func getPhotoSearchResult(tag : String, sort : PhotoSearchSortingOptions) -> PhotoSearchStreamModel {
        let cacheKey = PhotoSearchStreamModel.streamIdWithTag(tag: tag, sort: sort)
        return cacheController.getCachedResource(cacheKey: cacheKey, inCache: cacheController.photoSearchResultCache, creationCallback: { () -> PhotoSearchStreamModel in
            return PhotoSearchStreamModel(tag: tag, sort : sort)
        })
    }
    
    // Retrieve a copy of the specific user search result stream with keyword
    func getUserSearchResult(keyword : String) -> UserSearchResultModel {
        return cacheController.getCachedResource(cacheKey: keyword, inCache: cacheController.userSearchResultCache, creationCallback: { () -> UserSearchResultModel in
            return UserSearchResultModel(keyword: keyword)
        })
    }

    // Put a stream to cache
    func putStreamToCache(_ collection : StreamModel) {
        let cacheKey = NSString(string: collection.modelId!)
        cacheController.streamCache.setObject(collection, forKey: cacheKey)
    }

    // Put a photo search result to cache
    func putPhotoSearchResultToCache(_ collection : PhotoSearchStreamModel) {
        let cacheKey = NSString(string: collection.modelId!)
        cacheController.photoSearchResultCache.setObject(collection, forKey: cacheKey)
    }

    // Put a list of comments to cacheKey
    func putCommentsToCache(_ collection : CommentCollectionModel) {
        let cacheKey = NSString(string: collection.modelId!)
        cacheController.commentsCache.setObject(collection, forKey: cacheKey)
    }

    // Put a user search result to cache
    func putUserSearchResultToCache(_ collection : UserSearchResultModel) {
        let cacheKey = NSString(string: collection.modelId!)
        cacheController.userSearchResultCache.setObject(collection, forKey: cacheKey)
    }
}
