//
//  APIService+Streams.swift
//  Accented
//
//  Created by You, Tiangong on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

extension APIService {

    // Get photos from stream
    func getPhotos(streamType : StreamType, page : Int = 1, parameters:[String : String] = [:], success: (() -> Void)? = nil, failure : ((String) -> Void)? = nil) -> Void {
        let request = GetStreamPhotosRequest(streamType, page : page, params : parameters, success : success, failure : failure)
        request.ignoreCache = (page == 1)
        get(request: request)
    }
    
    // Search photos by keyword
    func searchPhotos(keyword : String, page : Int = 1, sort : PhotoSearchSortingOptions, parameters:[String : String] = [:], success: (() -> Void)? = nil, failure : ((String) -> Void)? = nil) -> Void {
        let request = SearchPhotosRequest(keyword: keyword, page: page, sort : sort, params: parameters, success: success, failure: failure)
        request.ignoreCache = (page == 1)
        get(request: request)
    }
    
    // Search photos by tag
    func searchPhotos(tag : String, page : Int = 1, sort : PhotoSearchSortingOptions, parameters:[String : String] = [:], success: (() -> Void)? = nil, failure : ((String) -> Void)? = nil) -> Void {
        let request = SearchPhotosRequest(tag: tag, page: page, sort : sort, params: parameters, success: success, failure: failure)
        request.ignoreCache = (page == 1)
        get(request: request)
    }
}
