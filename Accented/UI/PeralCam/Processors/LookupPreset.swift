//
//  LookupPreset.swift
//  Accented
//
//  Created by Tiangong You on 6/4/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

class LookupPreset: Preset {
    var lookImageName : String
    
    init(_ lookupImageName : String) {
        self.lookImageName = lookupImageName
        super.init()
        
        name = "LOOKUP"
        filter = LookupFilter()
        filter!.lookupImage = PictureInput(imageName: lookupImageName)
    }
}
