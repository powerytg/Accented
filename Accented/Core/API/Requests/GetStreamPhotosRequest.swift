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
    
    init(_ streamType : StreamType, page : Int = 1, params : [String : String], success : SuccessAction?, failure : FailureAction?) {
        self.streamType = streamType
        self.page = page
        
        super.init(success: success, failure: failure)
        
        cacheKey = "photos/\(streamType.rawValue)/\(page)"
        url = "\(APIRequest.baseUrl)photos"
        parameters = params
        parameters["feature"] = streamType.rawValue
        parameters["page"] = String(page)
        if params["image_size"] == nil {
            parameters["image_size"] = APIRequest.defaultImageSizesForStream.map({ (size) -> String in
                return size.rawValue
            }).joined(separator: ",")
        }
    }
    
    override func handleSuccess(data: Data, response: HTTPURLResponse?) {
        super.handleSuccess(data: data, response: response)
        let userInfo : [String : Any] = ["streamType" : streamType.rawValue,
                                         "page" : page,
                                         "response" : data]
        
        NotificationCenter.default.post(name: Notification.Name("streamPhotosDidReturn"), object: nil, userInfo: userInfo)
        
        if let success = successAction {
            success()
        }
    }
    
    override func handleFailure(_ error: Error) {
        super.handleFailure(error)
        
        let userInfo : [String : String] = ["errorMessage" : error.localizedDescription]
        NotificationCenter.default.post(name: Notification.Name("streamPhotosFailedReturn"), object: nil, userInfo: userInfo)
        
        if let failure = failureAction {
            failure(error.localizedDescription)
        }
    }
}
