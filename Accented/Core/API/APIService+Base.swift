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
        
        _ = client.get(request.url, parameters: request.parameters, success: { [weak self] (data, response) in
            request.handleSuccess(data: data, response: response)
            if let cacheKey = request.cacheKey {
                self?.removeFromPendingQueue(cacheKey)
                self?.putToCache(data, forKey: cacheKey)
            }
            
        }) { [weak self] (error) in
            if let cacheKey = request.cacheKey {
                self?.removeFromPendingQueue(cacheKey)
            }
            
            request.handleFailure(error)
        }
    }
    
}
