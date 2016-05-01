//
//  StreamTemplateGenerator.swift
//  Accented
//
//  Created by Tiangong You on 5/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamTemplateGenerator : NSObject {
    // Available width
    var availableWidth : CGFloat
    
    required init(maxWidth : CGFloat) {
        self.availableWidth = maxWidth
        super.init()
    }
    
    func generateLayoutMetadata(photos : [PhotoModel]) -> [StreamLayoutTemplate] {
        fatalError("Not implemented in base class")
    }
}

