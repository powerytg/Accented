//
//  GetUserFriendsPhotosRequest.swift
//  Accented
//
//  Created by Tiangong You on 9/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class GetUserFriendsPhotosRequest: APIRequest {
    
    private var streamType : StreamType = .UserFriends
    private var page : Int
    private var userId : String
    
    init(userId : String, page : Int = 1, params : [String : String], success : SuccessAction?, failure : FailureAction?) {
        self.page = page
        self.userId = userId
        
        super.init(success: success, failure: failure)
        
        cacheKey = "friends_photos/\(userId)/\(streamType.rawValue)/\(page)"
        url = "\(APIRequest.baseUrl)photos"
        parameters = params
        parameters[RequestParameters.feature] = streamType.rawValue
        parameters[RequestParameters.page] = String(page)
        parameters[RequestParameters.includeStates] = "1"
        parameters[RequestParameters.userId] = userId
        
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
        let userInfo : [String : Any] = [RequestParameters.feature : streamType.rawValue,
                                         RequestParameters.page : page,
                                         RequestParameters.userId : userId,
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
