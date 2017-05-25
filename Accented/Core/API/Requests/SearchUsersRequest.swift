//
//  SearchUsersRequest.swift
//  Accented
//
//  Created by Tiangong You on 5/22/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class SearchUsersRequest: APIRequest {
    private var keyword : String
    private var page : Int
    
    init(keyword : String, page : Int = 1, success : SuccessAction?, failure : FailureAction?) {
        self.keyword = keyword
        self.page = page
        
        super.init(success: success, failure: failure)
        
        cacheKey = "search_users/\(keyword)/\(page)"
        url = "\(APIRequest.baseUrl)users/search"
        parameters = [String : String]()
        parameters[RequestParameters.term] = keyword
        parameters[RequestParameters.page] = String(page)
    }
    
    override func handleSuccess(data: Data, response: HTTPURLResponse?) {
        super.handleSuccess(data: data, response: response)
        let userInfo : [String : Any] = [RequestParameters.page : page,
                                         RequestParameters.response : data,
                                         RequestParameters.term : keyword]
        
        NotificationCenter.default.post(name: APIEvents.userSearchResultDidReturn, object: nil, userInfo: userInfo)
        
        if let success = successAction {
            success()
        }
    }
    
    override func handleFailure(_ error: Error) {
        super.handleFailure(error)
        
        let userInfo : [String : String] = [RequestParameters.errorMessage : error.localizedDescription]
        NotificationCenter.default.post(name: APIEvents.userSearchResultFailedReturn, object: nil, userInfo: userInfo)
        
        if let failure = failureAction {
            failure(error.localizedDescription)
        }
    }
}
