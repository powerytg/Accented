//
//  GetUserFriendsRequest.swift
//  Accented
//
//  Request to retrieve user's friend list
//
//  Created by Tiangong You on 9/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class GetUserFriendsRequest: APIRequest {
    private var userId : String
    private var page : Int
    
    init(userId : String, page : Int = 1, success : SuccessAction?, failure : FailureAction?) {
        self.userId = userId
        self.page = page
        
        super.init(success: success, failure: failure)
        
        cacheKey = "users_friends/\(userId)/\(page)"
        url = "\(APIRequest.baseUrl)users/\(userId)/friends"
        parameters = [String : String]()
        parameters[RequestParameters.page] = String(page)
    }
    
    override func handleSuccess(data: Data, response: HTTPURLResponse?) {
        super.handleSuccess(data: data, response: response)
        let userInfo : [String : Any] = [RequestParameters.page : page,
                                         RequestParameters.response : data,
                                         RequestParameters.userId : userId]
        
        NotificationCenter.default.post(name: APIEvents.userFriendsDidReturn, object: nil, userInfo: userInfo)
        
        if let success = successAction {
            success()
        }
    }
    
    override func handleFailure(_ error: Error) {
        super.handleFailure(error)
        
        let userInfo : [String : String] = [RequestParameters.errorMessage : error.localizedDescription]
        NotificationCenter.default.post(name: APIEvents.userFriendsFailedReturn, object: nil, userInfo: userInfo)
        
        if let failure = failureAction {
            failure(error.localizedDescription)
        }
    }

}
