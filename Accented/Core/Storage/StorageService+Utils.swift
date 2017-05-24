//
//  StorageService+Utils.swift
//  Accented
//
//  Created by Tiangong You on 5/20/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

extension StorageService {
    // Merge in two model collections and return the result
    // If a model with a specific id already exists, it will be replaced with the new model
    internal func mergeModelCollections<T : ModelBase>(newModels : [T], withModels oldModels : [T]) -> [T] {
        var result = [T]()
        result.append(contentsOf: oldModels)
        var existingModels = [String : T]()
        for model in oldModels {
            if let modelId = model.modelId {
                existingModels[modelId] = model
            } else {
                debugPrint("Photo model id not found!")
            }
        }
        
        for model in newModels {
            if let modelId = model.modelId {
                if let existingModel = existingModels[modelId] {
                    // New model will replace the old model
                    let existingIndex = result.index(of: existingModel)
                    result[existingIndex!] = model
                } else {
                    result.append(model)
                }
            }
        }
        
        return result
    }
    
    // Synchronize on a given lock
    internal func synchronized(_ lock: AnyObject, _ block: () throws -> Void) rethrows {
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        try block()
    }
    
    // Whether the two specified collections contain the same objects (compared by modelId)
    internal func isEqualCollection(newItems : [ModelBase], oldItems : [ModelBase]) -> Bool {
        if newItems.count != oldItems.count {
            return false
        }
        
        for (index, _) in oldItems.enumerated() {
            if newItems[index].modelId != oldItems[index].modelId {
                return false
            }
        }
        
        return true
    }
}
