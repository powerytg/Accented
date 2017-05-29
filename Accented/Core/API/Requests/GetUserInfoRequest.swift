//
//  GetUserInfoRequest.swift
//  Accented
//
//  Get user profile request
//
//  Created by Tiangong You on 5/28/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class GetUserInfoRequest: APIRequest {
    private var userId : String
    
    init(userId : String, success : SuccessAction?, failure : FailureAction?) {
        self.userId = userId
        super.init(success: success, failure: failure)
        
        cacheKey = "user_profile_\(userId)"
        url = "\(APIRequest.baseUrl)users/show"
        parameters[RequestParameters.userId] = userId
    }
    
    override func handleSuccess(data: Data, response: HTTPURLResponse?) {
        super.handleSuccess(data: data, response: response)
        
        let userInfo : [String : Any] = [RequestParameters.userId : userId,
                                         RequestParameters.response : data]
        NotificationCenter.default.post(name: APIEvents.userProfileDidReturn, object: nil, userInfo: userInfo)
        
        if let success = successAction {
            success()
        }
    }
    
    override func handleFailure(_ error: Error) {
        super.handleFailure(error)
        
        let userInfo : [String : String] = [RequestParameters.errorMessage : error.localizedDescription]
        NotificationCenter.default.post(name: APIEvents.userProfileFailedReturn, object: nil, userInfo: userInfo)
        
        if let failure = failureAction {
            failure(error.localizedDescription)
        }
    }
}
