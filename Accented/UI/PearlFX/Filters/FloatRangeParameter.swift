//
//  FloatRangeParameter.swift
//  Accented
//
//  FloatRangeParameter is a FilterParameter that operates on a range of float values
//
//  Created by You, Tiangong on 6/8/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class FloatRangeParameter: FilterParameter {
    var minValue : Float!
    var maxValue : Float!
    var value : Float!
    
    init(name : String) {
        super.init(name: name, type: .floatRange)
    }
}
