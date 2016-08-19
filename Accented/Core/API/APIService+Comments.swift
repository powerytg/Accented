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
    func getComments(photoId : String, page : Int = 1, parameters:[String : String] = [:], success: (() -> Void)? = nil, failure : ((String) -> Void)? = nil) -> Void {
        let url = "\(baseUrl)photos/\(photoId)/comments"
        var params = parameters
        params["page"] = String(page)
        
        client.get(url, parameters: params, success: { (data, response) in
            let userInfo : [String : AnyObject] = ["photoId" : photoId, "page" : page, "response" : data]
            NSNotificationCenter.defaultCenter().postNotificationName("commentsDidReturn", object: nil, userInfo: userInfo)
            
            if let successAction = success {
                successAction()
            }
            
        }) { (error) in
            let userInfo : [String : String] = ["errorMessage" : error.localizedDescription]
            NSNotificationCenter.defaultCenter().postNotificationName("commentsFailedReturn", object: nil, userInfo: userInfo)
            
            if let failureAction = failure {
                failureAction(error.localizedDescription)
            }
        }
    }
}
