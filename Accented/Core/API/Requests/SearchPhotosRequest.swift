//
//  SearchPhotosRequest.swift
//  Accented
//
//  Created by Tiangong You on 5/21/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class SearchPhotosRequest: APIRequest {

    private var keyword : String?
    private var tag : String?
    private var page : Int
    private var sorting : PhotoSearchSortingOptions
    
    init(keyword : String, page : Int = 1, sort : PhotoSearchSortingOptions, params : [String : String], success : SuccessAction?, failure : FailureAction?) {
        self.keyword = keyword
        self.page = page
        self.sorting = sort
        
        super.init(success: success, failure: failure)
        
        cacheKey = "search_photos/\(keyword)/\(page)"
        url = "\(APIRequest.baseUrl)photos/search"
        parameters = params
        parameters[RequestParameters.term] = keyword
        parameters[RequestParameters.page] = String(page)
        parameters[RequestParameters.sort] = sort.rawValue
        parameters[RequestParameters.includeStates] = "1"
        
        if params[RequestParameters.imageSize] == nil {
            parameters[RequestParameters.imageSize] = APIRequest.defaultImageSizesForStream.map({ (size) -> String in
                return size.rawValue
            }).joined(separator: ",")
        }
        
        // By default, exclude node content
        parameters[RequestParameters.excludeNude] = "1"
        
        if params[RequestParameters.exclude] == nil {
            // Apply default filters
            parameters[RequestParameters.exclude] = APIRequest.defaultExcludedCategories.joined(separator: ",")
        }
    }
    
    init(tag : String, page : Int = 1, sort : PhotoSearchSortingOptions, params : [String : String], success : SuccessAction?, failure : FailureAction?) {
        self.tag = tag
        self.page = page
        self.sorting = sort
        
        super.init(success: success, failure: failure)
        
        cacheKey = "search_photos/\(tag)/\(page)"
        url = "\(APIRequest.baseUrl)photos/search"
        parameters = params
        parameters[RequestParameters.tag] = tag
        parameters[RequestParameters.page] = String(page)
        parameters[RequestParameters.sort] = sort.rawValue
        parameters[RequestParameters.includeStates] = "1"
        
        if params[RequestParameters.imageSize] == nil {
            parameters[RequestParameters.imageSize] = APIRequest.defaultImageSizesForStream.map({ (size) -> String in
                return size.rawValue
            }).joined(separator: ",")
        }

        // By default, exclude node content
        parameters[RequestParameters.excludeNude] = "1"
        
        if params[RequestParameters.exclude] == nil {
            // Apply default filters
            parameters[RequestParameters.exclude] = APIRequest.defaultExcludedCategories.joined(separator: ",")
        }
    }
    
    override func handleSuccess(data: Data, response: HTTPURLResponse?) {
        super.handleSuccess(data: data, response: response)
        var userInfo : [String : Any] = [RequestParameters.feature : StreamType.Search.rawValue,
                                         RequestParameters.page : page,
                                         RequestParameters.response : data,
                                         RequestParameters.sort : sorting]
        
        if keyword != nil {
            userInfo[RequestParameters.term] = keyword!
        } else if tag != nil {
            userInfo[RequestParameters.tag] = tag!
        }
        
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
