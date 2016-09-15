//
//  SideBySideTemplate.swift
//  Accented
//
//  Created by Tiangong You on 4/28/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class SideBySideTemplate: StreamLayoutTemplateBase {
    
    fileprivate let maxHeight : CGFloat = 200
    fileprivate let maxHorizontalRatio : CGFloat = 3.0 / 2.0
    
    override var capacity : Int {
        return 2
    }
    
    required init(photoSizes: Array<CGSize>, maxWidth: CGFloat) {
        super.init(photoSizes: photoSizes, maxWidth: maxWidth)
        generateLayoutMetadata()
    }
    
    fileprivate func generateLayoutMetadata() {
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
        
        let rect1 = CGRect(x: 0, y: 0, width: width1, height: height)
        let rect2 = CGRect(x: width1 + hGap, y: 0, width: width2, height: height)
        
        frames = [rect1, rect2]
    }
    
}
