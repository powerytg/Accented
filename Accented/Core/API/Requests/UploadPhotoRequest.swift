//
//  UploadPhotoRequest.swift
//  Accented
//
//  Created by Tiangong You on 8/28/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UploadPhotoRequest: APIRequest {
    init(name : String, description : String, category : Category, privacy : Privacy, image : Data, success : SuccessAction?, failure : FailureAction?) {
        super.init(success: success, failure: failure)
        
        ignoreCache = true
        url = "\(APIRequest.baseUrl)photos/upload"
        parameters[RequestParameters.name] = name
        parameters[RequestParameters.desc] = description
        parameters[RequestParameters.category] = String(category.rawValue)
        parameters[RequestParameters.privacy] = String(privacy.rawValue)
    }
    
    override func handleSuccess(data: Data, response: HTTPURLResponse?) {
        super.handleSuccess(data: data, response: response)
        let userInfo : [String : Any] = [RequestParameters.response : data]
        
        NotificationCenter.default.post(name: APIEvents.photoDidUpload, object: nil, userInfo: userInfo)
        
        if let success = successAction {
            success()
        }
    }
    
    override func handleFailure(_ error: Error) {
        super.handleFailure(error)
        
        let userInfo : [String : String] = [RequestParameters.errorMessage : error.localizedDescription]
        NotificationCenter.default.post(name: APIEvents.photoFailedUpload, object: nil, userInfo: userInfo)
        
        if let failure = failureAction {
            failure(error.localizedDescription)
        }
    }
}
