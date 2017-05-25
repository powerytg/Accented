//
//  ModelBase.swift
//  Accented
//
//  Base class of models
//
//  Created by Tiangong You on 5/20/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class ModelBase: NSObject, NSCopying {
    var modelId : String?
    
    func copy(with zone: NSZone? = nil) -> Any {
        let clone = ModelBase()
        clone.modelId = self.modelId
        return clone
    }
    
    public static func == (lhs: ModelBase, rhs: ModelBase) -> Bool {
        return lhs.modelId == rhs.modelId
    }
}
