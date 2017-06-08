//
//  FXBrightnessFilter.swift
//  Accented
//
//  Created by You, Tiangong on 6/8/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

class FXBrightnessFilter: FXFilter {
    
    let filter = BrightnessAdjustment()
    let param = FloatRangeParameter(name: "Brightness")
    
    override init() {
        super.init()
        name = "Brightness"
        type = .colorAdjustment
        processor = filter
        
        param.minValue = -1
        param.maxValue = 1
        param.value = 0
        parameters = [param]
    }
    
    override func apply() {
        filter.brightness = param.value
    }
}
