//
//  APIService+Comments.swift
//  Accented
//
//  Created by You, Tiangong on 8/19/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

extension APIService {

    // Get comments for a photo
    func getComments(_ photoId : String, page : Int = 1, parameters:[String : String] = [:], success: (() -> Void)? = nil, failure : ((String) -> Void)? = nil) -> Void {
        let url = "\(baseUrl)photos/\(photoId)/comments"
        var params = parameters
        params["page"] = String(page)
        
        _ = client.get(url, parameters: params, success: { [weak self] (data, response) in
            
            // If the page is 1, then treat this as a 'refresh' action. We'll mark the current time as the comments' last refreshed time
            self?.commentsLastRefreshedDateLookup[photoId] = Date()
            
            let userInfo : [String : Any] = ["photoId" : photoId, "page" : page, "response" : data]
            NotificationCenter.default.post(name: Notification.Name("commentsDidReturn"), object: nil, userInfo: userInfo)

            if let successAction = success {
                successAction()
            }
            
        }) { (error) in
            let userInfo : [String : String] = ["errorMessage" : error.localizedDescription]
            NotificationCenter.default.post(name: Notification.Name("commentsFailedReturn"), object: nil, userInfo: userInfo)
            
            if let failureAction = failure {
                failureAction(error.localizedDescription)
            }
        }
    }
    
    // Refresh a photo's comments if the previous comments in cache already expired
    func refreshCommentsIfNecessary(_ photoId : String, parameters:[String : String] = [:], success: (() -> Void)? = nil, failure : ((String) -> Void)? = nil) {
        // If the cache has not expired, return immediately
        if !commentsCacheExpired(photoId) {
            if let successAction = success {
                successAction()
                return
            }
        }
        
        getComments(photoId, page: 1, parameters: parameters, success: success, failure: failure)
    }
}
