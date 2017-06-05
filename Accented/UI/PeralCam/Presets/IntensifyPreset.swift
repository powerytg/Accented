//
//  IntensifyPreset.swift
//  Accented
//
//  Created by Tiangong You on 6/4/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

class IntensifyPreset: Preset {
    
    override init() {
        super.init()
        name = "LOMO"
        filter = LookupFilter()
        filter.lookupImage = PictureInput(imageName: "Intensify.png")
    }
    
}
