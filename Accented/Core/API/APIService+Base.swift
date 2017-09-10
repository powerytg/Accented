//
//  APIService+Base.swift
//  Accented
//
//  Created by You, Tiangong on 9/20/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

extension APIService {
    
    func get(request : APIRequest) -> Void {
        if let cacheKey = request.cacheKey {
            // Check for duplicated requests
            if isInPendingQueue(cacheKey) {
                return
            } else {
                addToPendingQueue(cacheKey)
            }
            
            // Retrieve from cache if available
            if !request.ignoreCache , let cachedResponse = getFromCache(request.cacheKey!){
                debugPrint("Cache hit: \(cacheKey)")
                removeFromPendingQueue(cacheKey)
                request.handleSuccess(data: cachedResponse, response: nil)
                return
            } else {
                debugPrint("Cache miss: \(cacheKey)")
            }
        }

        _ = client.get(request.url, parameters: request.parameters, headers: nil, success: { [weak self] (response) in
            if let cacheKey = request.cacheKey {
                self?.removeFromPendingQueue(cacheKey)
                self?.putToCache(response.data, forKey: cacheKey)
            }
            
            request.handleSuccess(data: response.data, response: response.response)
        }, failure: { [weak self] (error) in
            if let cacheKey = request.cacheKey {
                self?.removeFromPendingQueue(cacheKey)
            }

            debugPrint(error)
            request.handleFailure(error)
        })
    }
    
    func post(request : APIRequest) -> Void {
        _ = client.post(request.url, parameters: request.parameters, headers: nil, success: { (response) in
            request.handleSuccess(data: response.data, response: response.response)
            }, failure: { (error) in
                debugPrint(error)
                request.handleFailure(error)
        })
    }
    
    func delete(request : APIRequest) -> Void {
        _ = client.delete(request.url, parameters: request.parameters, headers: nil, success: { (response) in
            request.handleSuccess(data: response.data, response: response.response)
        }, failure: { (error) in
            debugPrint(error)
            request.handleFailure(error)
        })
    }

}
