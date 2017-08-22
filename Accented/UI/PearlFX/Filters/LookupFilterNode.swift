//
//  LookupFilterNode.swift
//  Accented
//
//  Created by Tiangong You on 6/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

class LookupFilterNode: FilterNode {
    
    var lut = LookupFilter()
    
    init() {
        super.init(filter: lut)
        enabled = false
    }
    
    var lookupImageName : String? {
        didSet {
            if lookupImageName == nil {
                lut.lookupImage = nil
                enabled = false
            } else {
                lut.lookupImage = PictureInput(imageName: lookupImageName!)
                enabled = true
            }
        }
    }
    
    override func cloneFilter() -> FilterNode? {
        let clone = LookupFilterNode()
        clone.enabled = enabled
        clone.lookupImageName = lookupImageName
        return clone
    }
}
