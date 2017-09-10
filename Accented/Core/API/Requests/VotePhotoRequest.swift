//
//  VotePhotoRequest.swift
//  Accented
//
//  Request to vote a photo
//
//  Created by Tiangong You on 9/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class VotePhotoRequest: APIRequest {
    private var photoId : String
    
    init(photoId : String, success : SuccessAction?, failure : FailureAction?) {
        self.photoId = photoId
        
        super.init(success: success, failure: failure)
        ignoreCache = true
        url = "\(APIRequest.baseUrl)photos/\(photoId)/vote"
        
        // Currently we only support upvote a photo
        parameters = [RequestParameters.vote : "1"]
    }
    
    override func handleSuccess(data: Data, response: HTTPURLResponse?) {
        super.handleSuccess(data: data, response: response)
        let userInfo : [String : Any] = [RequestParameters.photoId : photoId,
                                         RequestParameters.response : data]
        
        NotificationCenter.default.post(name: APIEvents.photoDidVote, object: nil, userInfo: userInfo)
        
        if let success = successAction {
            success()
        }
    }
    
    override func handleFailure(_ error: Error) {
        super.handleFailure(error)
        
        let userInfo : [String : String] = [RequestParameters.errorMessage : error.localizedDescription]
        NotificationCenter.default.post(name: APIEvents.photoFailedVote, object: nil, userInfo: userInfo)
        
        if let failure = failureAction {
            failure(error.localizedDescription)
        }
    }
}

