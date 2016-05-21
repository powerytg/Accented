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
        super.init(photoSizes: [CGSizeMake(width, height)], maxWidth: width)
        self.height = height
        self.frames = [CGRectMake(0, 0, width, height)]
    }
    
    required init(photoSizes: Array<CGSize>, maxWidth: CGFloat) {
        fatalError("init(photoSizes:maxWidth:) has not been implemented")
    }
}
