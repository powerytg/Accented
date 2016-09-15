//
//  JournalLayoutTemplate.swift
//  Accented
//
//  Created by Tiangong You on 5/20/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class JournalLayoutTemplate: StreamLayoutTemplateBase {
    required init(width : CGFloat, height : CGFloat) {
        super.init(photoSizes: [CGSize(width: width, height: height)], maxWidth: width)
        self.height = height
        self.frames = [CGRect(x: 0, y: 0, width: width, height: height)]
    }
    
    required init(photoSizes: Array<CGSize>, maxWidth: CGFloat) {
        fatalError("init(photoSizes:maxWidth:) has not been implemented")
    }
}
