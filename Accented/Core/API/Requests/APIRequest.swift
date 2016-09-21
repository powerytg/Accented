//
//  APIRequest.swift
//  Accented
//
//  Created by You, Tiangong on 9/16/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

// API success action
typealias SuccessAction = (() -> Void)

// API failure action
typealias FailureAction = ((String) -> Void)

class APIRequest: NSObject {
    
    // API base url
    static let baseUrl = "https://api.500px.com/v1/"
    
    // Supported image sizes
    static let defaultImageSizesForStream = [ImageSize.Small, ImageSize.Medium, ImageSize.Large]
    
    // Success action
    var successAction : SuccessAction?
    
    // Failure action
    var failureAction : FailureAction?
    
    // Url
    var url : String!
    
    // Params
    var parameters = [String : String]()
    
    // Cache key
    var cacheKey : String?
    
    init(success : SuccessAction?, failure : FailureAction?) {
        super.init()
        self.successAction = success
        self.failureAction = failure
    }
    
    func handleSuccess(data : Data, response : HTTPURLResponse?) {
        
    }
    
    func handleFailure(_ error : Error) {
        debugPrint(error)
    }

}

