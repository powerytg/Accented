//
//  FXFilter.swift
//  Accented
//
//  PearlFX filter plugin
//
//  Created by You, Tiangong on 6/8/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

enum FXFilterType {
    case colorAdjustment
}

class FXFilter: NSObject {
    var name : String!
    var type : FXFilterType!
    var processor : BasicOperation!
    var parameters : [FilterParameter]?
    
    func apply() {
        // Subclasses should apply the filter effect in this method, typically based on the parameters specified by the user
    }
}
