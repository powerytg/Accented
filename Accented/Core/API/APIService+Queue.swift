//
//  APIService+Queue.swift
//  Accented
//
//  Queue management
//
//  Created by You, Tiangong on 9/20/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

extension APIService {
    
    internal func addToPendingQueue(_ identifier : String) {
        if !pendingRequestQueue.contains(identifier) {
            pendingRequestQueue.append(identifier)
        }
    }
    
    internal func removeFromPendingQueue(_ identifier : String) {
        DispatchQueue.main.async(execute: { [weak self] in
            if let index = self?.pendingRequestQueue.index(of: identifier) {
                self?.pendingRequestQueue.remove(at: index)
            }
            })
    }
    
    internal func isInPendingQueue(_ identifier : String) -> Bool {
        return pendingRequestQueue.contains(identifier)
    }
    
}
