//
//  WhitebalanceFilterNode.swift
//  PearlCam
//
//  Created by Tiangong You on 6/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

class WhitebalanceFilterNode: FilterNode {
    
    var wbFilter = WhiteBalance()
    
    init() {
        super.init(filter: wbFilter)
        enabled = true
    }
    
    var temperature : Float? {
        didSet {
            if temperature != nil {
                wbFilter.temperature = temperature!
            }
        }
    }
    
    var tint : Float? {
        didSet {
            if tint != nil {
                wbFilter.tint = tint!
            }
        }
    }
    
    override func cloneFilter() -> FilterNode? {
        let clone = WhitebalanceFilterNode()
        clone.enabled = enabled
        clone.temperature = temperature
        clone.tint = tint
        return clone
    }
}
