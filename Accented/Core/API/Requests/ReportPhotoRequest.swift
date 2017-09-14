//
//  ReportPhotoRequest.swift
//  Accented
//
//  Created by Tiangong You on 9/13/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class ReportPhotoRequest: APIRequest {
    private var photoId : String
    private var reason : ReportReason
    private var details : String?
    
    init(photoId : String, reason : ReportReason, details : String?, success : SuccessAction?, failure : FailureAction?) {
        self.photoId = photoId
        self.reason = reason
        self.details = details
        super.init(success: success, failure: failure)
        
        ignoreCache = true
        url = "\(APIRequest.baseUrl)photos/\(photoId)/report"
        
        parameters["reason"] = reason.rawValue
        if let detailReason = details {
            parameters["reason_details"] = detailReason
        }
    }
    
    override func handleSuccess(data: Data, response: HTTPURLResponse?) {
        super.handleSuccess(data: data, response: response)
        let userInfo : [String : Any] = [RequestParameters.photoId : photoId,
                                         RequestParameters.response : data]
        
        NotificationCenter.default.post(name: APIEvents.didReportPhoto, object: nil, userInfo: userInfo)
        
        if let success = successAction {
            success()
        }
    }
    
    override func handleFailure(_ error: Error) {
        super.handleFailure(error)
        
        let userInfo : [String : String] = [RequestParameters.errorMessage : error.localizedDescription]
        NotificationCenter.default.post(name: APIEvents.failedReportPhoto, object: nil, userInfo: userInfo)
        
        if let failure = failureAction {
            failure(error.localizedDescription)
        }
    }
}
