//
//  StorageService+Cache.swift
//  Accented
//
//  Created by You, Tiangong on 9/16/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

extension StorageService {
    
    // MARK : - Read operations
    
    // Retrieve a copy of the user from cache
    func getUser(_ userId : String) -> UserModel? {
        return cacheController.userCache.object(forKey: NSString(string: userId))
    }
    
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

    // Retrieve a user profile
    func getUserProfile(userId : String) -> UserModel? {
        return cacheController.userProfileCache.object(forKey: NSString(string : userId))
    }

    // Retrieve the followers of an user
    func getUserFollowers(userId : String) -> UserFollowersModel {
        return cacheController.getCachedResource(cacheKey: userId, inCache: cacheController.userFollowersCache, creationCallback: { () -> UserFollowersModel in
            return UserFollowersModel(userId : userId)
        })
    }

    // Retrieve the friends of an user
    func getUserFriends(userId : String) -> UserFriendsModel {
        return cacheController.getCachedResource(cacheKey: userId, inCache: cacheController.userFriendsCache, creationCallback: { () -> UserFriendsModel in
            return UserFriendsModel(userId : userId)
        })
    }

    // Retrieve a user's photo stream from cache
    func getUserStream(userId : String) -> UserStreamModel {
        let cacheKey = userId
        return cacheController.getCachedResource(cacheKey: cacheKey, inCache: cacheController.userPhotoCache, creationCallback: { () -> UserStreamModel in
            return UserStreamModel(userId : userId)
        })
    }

    // Retrieve a user's galleries from cache
    func getUserGalleries(userId : String) -> GalleryCollectionModel {
        let cacheKey = userId
        return cacheController.getCachedResource(cacheKey: cacheKey, inCache: cacheController.userGalleryCache, creationCallback: { () -> GalleryCollectionModel in
            return GalleryCollectionModel(userId : userId)
        })
    }
    
    // Retrieve a user's gallery photos from cache
    func getGalleryPhotoStream(userId : String, galleryId : String) -> GalleryStreamModel {
        let cacheKey = "\(userId)_\(galleryId)"
        return cacheController.getCachedResource(cacheKey: cacheKey, inCache: cacheController.galleryPhotoCache, creationCallback: { () -> GalleryStreamModel in
            return GalleryStreamModel(userId : userId, galleryId : galleryId)
        })
    }

    // MARK : - Write operations
    
    // Put a user to cache
    func putUserToCache(_ user : UserModel) {
        cacheController.userCache.setObject(user, forKey: NSString(string: user.userId))
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
    
    // Put a user profile to cache
    func putUserProfileToCache(_ user : UserModel) {
        let cacheKey = NSString(string: user.userId)
        cacheController.userProfileCache.setObject(user, forKey: cacheKey)
    }
    
    // Put a user follower collection to cache
    func putUserFollowersToCache(_ collection : UserFollowersModel) {
        let cacheKey = NSString(string: collection.modelId!)
        cacheController.userFollowersCache.setObject(collection, forKey: cacheKey)
    }

    // Put a user friends collection to cache
    func putUserFriendsToCache(_ collection : UserFriendsModel) {
        let cacheKey = NSString(string: collection.modelId!)
        cacheController.userFriendsCache.setObject(collection, forKey: cacheKey)
    }

    // Put a user stream to cache
    func putUserStreamToCache(_ collection : UserStreamModel) {
        let cacheKey = NSString(string: collection.modelId!)
        cacheController.userPhotoCache.setObject(collection, forKey: cacheKey)
    }

    // Put a user gallery collection to cache
    func putUserGalleriesToCache(_ collection : GalleryCollectionModel) {
        let cacheKey = NSString(string: collection.modelId!)
        cacheController.userGalleryCache.setObject(collection, forKey: cacheKey)
    }
    
    // Put a gallery stream to cache
    func putGalleryStreamToCache(_ collection : GalleryStreamModel) {
        let cacheKey = NSString(string: collection.modelId!)
        cacheController.galleryPhotoCache.setObject(collection, forKey: cacheKey)
    }
}
