//
//  GetCommentsRequest.swift
//  Accented
//
//  Load photo comments request
//
//  Created by You, Tiangong on 9/20/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class GetCommentsRequest: APIRequest {
    
    private var photoId : String
    private var page : Int
    
    init(_ photoId : String, page : Int = 1, params : [String : String], success : SuccessAction?, failure : FailureAction?) {
        self.photoId = photoId
        self.page = page
        super.init(success: success, failure: failure)
        
        cacheKey = "photos/\(photoId)/comments/\(page)"
        url = "\(APIRequest.baseUrl)photos/\(photoId)/comments"
        parameters = params
        parameters[RequestParameters.page] = String(page)
    }
    
    override func handleSuccess(data: Data, response: HTTPURLResponse?) {
        super.handleSuccess(data: data, response: response)
        
        let userInfo : [String : Any] = [RequestParameters.photoId : photoId,
                                         RequestParameters.page : page,
                                         RequestParameters.response : data]
        NotificationCenter.default.post(name: APIEvents.commentsDidReturn, object: nil, userInfo: userInfo)
        
        if let success = successAction {
            success()
        }
    }
    
    override func handleFailure(_ error: Error) {
        super.handleFailure(error)
        
        let userInfo : [String : String] = [RequestParameters.errorMessage : error.localizedDescription]
        NotificationCenter.default.post(name: APIEvents.commentsFailedReturn, object: nil, userInfo: userInfo)
        
        if let failure = failureAction {
            failure(error.localizedDescription)
        }
    }
}
