//
//  ExposureFilterNode.swift
//  Accented
//
//  Created by Tiangong You on 6/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

class ExposureFilterNode: FilterNode {
    
    var expFilter = ExposureAdjustment()
    
    init() {
        super.init(filter: expFilter)
        enabled = true
    }
    
    var exposure : Float? {
        didSet {
            if exposure != nil {
                expFilter.exposure = exposure!
            }
        }
    }
    
    override func cloneFilter() -> FilterNode? {
        let clone = ExposureFilterNode()
        clone.enabled = enabled
        clone.exposure = exposure
        return clone
    }
}
