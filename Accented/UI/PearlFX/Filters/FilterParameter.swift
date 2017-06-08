//
//  FilterParameter.swift
//  Accented
//
//  A FilterParameter describes one single setting for a fx filter
//
//  Created by You, Tiangong on 6/8/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

// Parameter type describes how we should present the UI for the specific filter parameter
enum ParameterType {
    // Float range from a min value to a max value
    case floatRange
    
    // A color value
    case color
}

class FilterParameter : NSObject {
    var name : String
    var type : ParameterType
    
    init(name : String, type : ParameterType) {
        self.name = name
        self.type = type
        super.init()
    }
}
