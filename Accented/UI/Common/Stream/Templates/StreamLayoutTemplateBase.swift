//
//  StreamLayoutTemplateBase.swift
//  Accented
//
//  Created by Tiangong You on 4/28/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamLayoutTemplateBase: NSObject, StreamLayoutTemplate {
    
    // Horizontal gap between columns
    let hGap : CGFloat = 20
    
    // Vertical gap between rows
    let vGap : CGFloat = 20
    
    // Max width
    var width : CGFloat
    
    var height : CGFloat = 0
    var inputSizes : Array<CGSize> = []
    var frames = Array<CGRect>()
    
    
    // Max number of photo items the template could manage
    var capacity : Int {
        return 1
    }
    
    required init(photoSizes: Array<CGSize>, maxWidth : CGFloat) {
        self.width = maxWidth
        self.inputSizes = photoSizes
        
        super.init()
    }

}
