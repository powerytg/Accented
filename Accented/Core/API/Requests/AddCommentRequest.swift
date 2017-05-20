//
//  AddCommentRequest.swift
//  Accented
//
//  Post comment request
//
//  Created by Tiangong You on 5/20/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class AddCommentRequest: APIRequest {
    
    private var photoId : String
    private var content : String
    
    init(_ photoId : String, content : String, success : SuccessAction?, failure : FailureAction?) {
        self.photoId = photoId
        self.content = content
        super.init(success: success, failure: failure)
        
        url = "\(APIRequest.baseUrl)photos/\(photoId)/comments"
        parameters[RequestParameters.body] = content
    }
    
    override func handleSuccess(data: Data, response: HTTPURLResponse?) {
        super.handleSuccess(data: data, response: response)
        
        let userInfo : [String : Any] = [RequestParameters.photoId : photoId,
                                         RequestParameters.response : data]
        NotificationCenter.default.post(name: APIEvents.commentDidPost, object: nil, userInfo: userInfo)
        
        if let success = successAction {
            success()
        }
    }
    
    override func handleFailure(_ error: Error) {
        super.handleFailure(error)
        
        let userInfo : [String : String] = [RequestParameters.errorMessage : error.localizedDescription]
        NotificationCenter.default.post(name: APIEvents.commentFailedPost, object: nil, userInfo: userInfo)
        
        if let failure = failureAction {
            failure(error.localizedDescription)
        }
    }
}
