//
//  APIService+Users.swift
//  Accented
//
//  User APIs
//
//  Created by Tiangong You on 5/22/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

extension APIService {
    
    // Search for users
    func searchUsers(keyword : String, page : Int = 1, success: (() -> Void)? = nil, failure : ((String) -> Void)? = nil) {
        let request = SearchUsersRequest(keyword : keyword, page : page, success : success, failure : failure)
        get(request: request)
    }
    
    // Get user profile
    func getUserProfile(userId : String, success: (() -> Void)? = nil, failure : ((String) -> Void)? = nil) {
        let request = GetUserInfoRequest(userId : userId, success : success, failure : failure)
        get(request: request)
    }
    
    // Get current user profile
    func getCurrentUserProfile(success: (() -> Void)? = nil, failure : ((String) -> Void)? = nil) {
        let request = GetCurrentUserInfoRequest(success: success, failure: failure)
        get(request: request)
    }

    // Get user followers
    func getUserFollowers(userId : String, page : Int = 1, success: (() -> Void)? = nil, failure : ((String) -> Void)? = nil) {
        let request = GetUserFollowersRequest(userId: userId, page: page, success: success, failure: failure)
        get(request: request)
    }

    // Get user friends
    func getUserFriends(userId : String, page : Int = 1, success: (() -> Void)? = nil, failure : ((String) -> Void)? = nil) {
        let request = GetUserFriendsRequest(userId: userId, page: page, success: success, failure: failure)
        get(request: request)
    }
    
    // Follow user
    func followUser(userId : String, success: (() -> Void)? = nil, failure : ((String) -> Void)? = nil) {
        let request = FollowUserRequest(userId: userId, success: success, failure: failure)
        post(request: request)
    }
    
    // Unfollow user
    func unfollowUser(userId : String, success: (() -> Void)? = nil, failure : ((String) -> Void)? = nil) {
        let request = UnfollowUserRequest(userId: userId, success: success, failure: failure)
        delete(request: request)
    }

}

