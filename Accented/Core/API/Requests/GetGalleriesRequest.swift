//
//  GetGalleriesRequest.swift
//  Accented
//
//  Get user galleries request
//
//  Created by You, Tiangong on 6/2/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class GetGalleriesRequest: APIRequest {
    private var userId : String
    private var page : Int
    
    init(_ userId : String, page : Int = 1, params : [String : String], success : SuccessAction?, failure : FailureAction?) {
        self.userId = userId
        self.page = page
        
        super.init(success: success, failure: failure)
        
        cacheKey = "galleries/\(userId)/\(page)"
        url = "\(APIRequest.baseUrl)users/\(userId)/galleries"
        parameters = params
        parameters[RequestParameters.page] = String(page)
        parameters[RequestParameters.includeCover] = "1"
        parameters[RequestParameters.coverSize] = ImageSize.Large.rawValue
    }
    
    override func handleSuccess(data: Data, response: HTTPURLResponse?) {
        super.handleSuccess(data: data, response: response)
        let userInfo : [String : Any] = [RequestParameters.userId : userId,
                                         RequestParameters.page : page,
                                         RequestParameters.response : data]
        
        NotificationCenter.default.post(name: APIEvents.userGalleriesDidReturn, object: nil, userInfo: userInfo)
        
        if let success = successAction {
            success()
        }
    }
    
    override func handleFailure(_ error: Error) {
        super.handleFailure(error)
        
        let userInfo : [String : String] = [RequestParameters.errorMessage : error.localizedDescription]
        NotificationCenter.default.post(name: APIEvents.userGalleriesFailedReturn, object: nil, userInfo: userInfo)
        
        if let failure = failureAction {
            failure(error.localizedDescription)
        }
    }
}
