//
//  GetCurrentUserInfoRequest.swift
//  Accented
//
//  Get the current logged in user's profile
//
//  Created by You, Tiangong on 6/2/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class GetCurrentUserInfoRequest: APIRequest {
    override init(success : SuccessAction?, failure : FailureAction?) {
        super.init(success: success, failure: failure)
        ignoreCache = true
        url = "\(APIRequest.baseUrl)users"
    }
    
    override func handleSuccess(data: Data, response: HTTPURLResponse?) {
        super.handleSuccess(data: data, response: response)
        
        let userInfo : [String : Any] = [RequestParameters.response : data]
        NotificationCenter.default.post(name: APIEvents.currentUserProfileDidReturn, object: nil, userInfo: userInfo)
        
        if let success = successAction {
            success()
        }
    }
    
    override func handleFailure(_ error: Error) {
        super.handleFailure(error)
        
        let userInfo : [String : String] = [RequestParameters.errorMessage : error.localizedDescription]
        NotificationCenter.default.post(name: APIEvents.currentUserProfileFailedReturn, object: nil, userInfo: userInfo)
        
        if let failure = failureAction {
            failure(error.localizedDescription)
        }
    }
}
