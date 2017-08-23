//
//  ColorFilterNode.swift
//  PearlCam
//
//  Created by Tiangong You on 6/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

class ColorFilterNode: FilterNode {

    var rgbFilter = RGBAdjustment()
    
    init() {
        super.init(filter: rgbFilter)
        enabled = true
    }
    
    var red : Float? {
        didSet {
            if red != nil {
                rgbFilter.red = red!
            }
        }
    }

    var green : Float? {
        didSet {
            if green != nil {
                rgbFilter.green = green!
            }
        }
    }

    var blue : Float? {
        didSet {
            if blue != nil {
                rgbFilter.blue = blue!
            }
        }
    }

    override func cloneFilter() -> FilterNode? {
        let clone = ColorFilterNode()
        clone.enabled = enabled
        clone.red = red
        clone.green = green
        clone.blue = blue
        return clone
    }
}
