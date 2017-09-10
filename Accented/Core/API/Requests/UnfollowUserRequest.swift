//
//  UnfollowUserRequest.swift
//  Accented
//
//  Request to unfollow user
//
//  Created by Tiangong You on 9/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UnfollowUserRequest: APIRequest {
    private var userId : String
    
    init(userId : String, success : SuccessAction?, failure : FailureAction?) {
        self.userId = userId
        
        super.init(success: success, failure: failure)
        ignoreCache = true
        url = "\(APIRequest.baseUrl)users/\(userId)/friends"
    }
    
    override func handleSuccess(data: Data, response: HTTPURLResponse?) {
        super.handleSuccess(data: data, response: response)
        let userInfo : [String : Any] = [RequestParameters.userId : userId,
                                         RequestParameters.response : data]
        
        NotificationCenter.default.post(name: APIEvents.didUnfollowUser, object: nil, userInfo: userInfo)
        
        if let success = successAction {
            success()
        }
    }
    
    override func handleFailure(_ error: Error) {
        super.handleFailure(error)
        
        let userInfo : [String : String] = [RequestParameters.errorMessage : error.localizedDescription]
        NotificationCenter.default.post(name: APIEvents.failedUnfollowUser, object: nil, userInfo: userInfo)
        
        if let failure = failureAction {
            failure(error.localizedDescription)
        }
    }
}
