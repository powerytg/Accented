//
//  GetStreamPhotosRequest.swift
//  Accented
//
//  Created by You, Tiangong on 9/20/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class GetStreamPhotosRequest: APIRequest {
    
    private var streamType : StreamType
    private var page : Int
    private var userId : String?
    
    init(_ streamType : StreamType, page : Int = 1, params : [String : String], success : SuccessAction?, failure : FailureAction?) {
        self.streamType = streamType
        self.page = page
        
        super.init(success: success, failure: failure)
        
        cacheKey = "photos/\(streamType.rawValue)/\(page)"
        url = "\(APIRequest.baseUrl)photos"
        parameters = params
        parameters[RequestParameters.feature] = streamType.rawValue
        parameters[RequestParameters.page] = String(page)
        parameters[RequestParameters.includeStates] = "1"
        
        // If the type of userFriends, then use current user's id by default
        if streamType == .UserFriends && StorageService.sharedInstance.currentUser != nil {
            userId = StorageService.sharedInstance.currentUser!.userId
            parameters[RequestParameters.userId] = userId
        }
        
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
        var userInfo : [String : Any] = [RequestParameters.feature : streamType.rawValue,
                                         RequestParameters.page : page,
                                         RequestParameters.response : data]
        
        if userId != nil {
            userInfo[RequestParameters.userId] = userId!
        }
        
        NotificationCenter.default.post(name: APIEvents.streamPhotosDidReturn, object: nil, userInfo: userInfo)
        
        if let success = successAction {
            success()
        }
    }
    
    override func handleFailure(_ error: Error) {
        super.handleFailure(error)
        
        var userInfo : [String : String] = [RequestParameters.errorMessage : error.localizedDescription]
        if userId != nil {
            userInfo[RequestParameters.userId] = userId!
        }

        NotificationCenter.default.post(name: APIEvents.streamPhotosFailedReturn, object: nil, userInfo: userInfo)
        
        if let failure = failureAction {
            failure(error.localizedDescription)
        }
    }
}
