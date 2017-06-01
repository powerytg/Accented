//
//  GetUserPhotosRequest.swift
//  Accented
//
//  Get user photos request
//
//  Created by Tiangong You on 5/31/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class GetUserPhotosRequest: APIRequest {
    private var page : Int
    private var userId : String
    
    init(userId : String, page : Int = 1, params : [String : String], success : SuccessAction?, failure : FailureAction?) {
        self.userId = userId
        self.page = page
        super.init(success: success, failure: failure)
        
        cacheKey = "photos/\(userId)/\(page)"
        url = "\(APIRequest.baseUrl)photos"
        parameters = params
        parameters[RequestParameters.feature] = "user"
        parameters[RequestParameters.userId] = userId
        parameters[RequestParameters.page] = String(page)
        parameters[RequestParameters.includeStates] = "1"
        
        if params[RequestParameters.imageSize] == nil {
            parameters[RequestParameters.imageSize] = APIRequest.defaultImageSizesForStream.map({ (size) -> String in
                return size.rawValue
            }).joined(separator: ",")
        }
        
        if params[RequestParameters.exclude] == nil {
            // Apply default filters
            parameters[RequestParameters.exclude] = APIRequest.defaultExcludedCategories.joined(separator: ",")
        }
    }
    
    override func handleSuccess(data: Data, response: HTTPURLResponse?) {
        super.handleSuccess(data: data, response: response)
        let userInfo : [String : Any] = [RequestParameters.feature : StreamType.User.rawValue,
                                         RequestParameters.userId : userId,
                                         RequestParameters.page : page,
                                         RequestParameters.response : data]
        
        NotificationCenter.default.post(name: APIEvents.streamPhotosDidReturn, object: nil, userInfo: userInfo)
        
        if let success = successAction {
            success()
        }
    }
    
    override func handleFailure(_ error: Error) {
        super.handleFailure(error)
        
        let userInfo : [String : String] = [RequestParameters.errorMessage : error.localizedDescription]
        NotificationCenter.default.post(name: APIEvents.streamPhotosFailedReturn, object: nil, userInfo: userInfo)
        
        if let failure = failureAction {
            failure(error.localizedDescription)
        }
    }
}
