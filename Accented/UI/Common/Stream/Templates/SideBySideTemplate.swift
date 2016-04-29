//
//  SideBySideTemplate.swift
//  Accented
//
//  Created by Tiangong You on 4/28/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class SideBySideTemplate: StreamLayoutTemplateBase {
    
    private let maxHeight : CGFloat = 200
    private let maxHorizontalRatio : CGFloat = 3.0 / 2.0
    
    required init(photoSizes: Array<CGSize>, maxWidth: CGFloat) {
        super.init(photoSizes: photoSizes, maxWidth: maxWidth)
        generateLayoutMetadata()
    }
    
    private func generateLayoutMetadata() {
        let size1 = inputSizes[0]
        let size2 = inputSizes[1]
        
        let aspectRatio1 = maxHeight / size1.height
        var width1 = size1.width * aspectRatio1
        
        let aspectRatio2 = maxHeight / size2.height
        var width2 = size2.width * aspectRatio2
        
        let hRatio = min(maxHorizontalRatio, width1 / width2)
        let ratio1 = hRatio / (1.0 + hRatio)
        
        width1 = (width - hGap) * ratio1
        let height1 = (width1 / size1.width) * size1.height
        
        width2 = width - hGap - width1
        let height2 = (width2 / size2.width) * size2.height
        
        height = min(maxHeight, min(height1, height2))
        
        let rect1 = CGRectMake(0, 0, width1, height)
        let rect2 = CGRectMake(width1 + hGap, 0, width2, height)
        
        frames = [rect1, rect2]
    }
    
}
