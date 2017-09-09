//
//  GetGalleryPhotosRequest.swift
//  Accented
//
//  Requst to retrieve gallery photos
//
//  Created by Tiangong You on 9/8/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class GetGalleryPhotosRequest: APIRequest {
    private var page : Int
    private var userId : String
    private var galleryId : String
    
    init(userId : String, galleryId : String, page : Int = 1, params : [String : String], success : SuccessAction?, failure : FailureAction?) {
        self.galleryId = galleryId
        self.userId = userId
        self.page = page
        super.init(success: success, failure: failure)
        
        cacheKey = "gallery_photos/\(userId)/\(galleryId)/\(page)"
        url = "\(APIRequest.baseUrl)users/\(userId)/galleries/\(galleryId)/items"
        parameters = params
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
        let userInfo : [String : Any] = [RequestParameters.feature : StreamType.Gallery.rawValue,
                                         RequestParameters.userId : userId,
                                         RequestParameters.galleryId : galleryId,
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
