//
//  VibranceFilterNode.swift
//  PearlCam
//
//  Created by Tiangong You on 6/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

class VibranceFilterNode: FilterNode {

    var vibranceFilter = Vibrance()
    
    init() {
        super.init(filter: vibranceFilter)
        enabled = true
    }
    
    var vibrance : Float? {
        didSet {
            if vibrance != nil {
                vibranceFilter.vibrance = vibrance!
            }
        }
    }
    
    override func cloneFilter() -> FilterNode? {
        let clone = VibranceFilterNode()
        clone.enabled = enabled
        clone.vibrance = vibrance
        return clone
    }
}
