//
//  HeadlineTemplate.swift
//  Accented
//
//  Created by Tiangong You on 4/30/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class HeadlineTemplate: StreamLayoutTemplateBase {

    private let maxFirstRowHeight : CGFloat = 500
    private let maxSecondRowHeight : CGFloat = 200
    private let maxHorizontalRatio : CGFloat = 3.0 / 2.0
    
    override var capacity : Int {
        return 3
    }
    
    required init(photoSizes: Array<CGSize>, maxWidth: CGFloat) {
        super.init(photoSizes: photoSizes, maxWidth: maxWidth)
        generateLayoutMetadata()
    }
    
    private func generateLayoutMetadata() {
        // First row
        let firstRowSize = inputSizes[0]
        let aspectRatio = width / firstRowSize.width
        let firstRowHeight = min(maxFirstRowHeight, firstRowSize.height * aspectRatio)
        let firstRowRect = CGRectMake(0, 0, width, firstRowHeight)
        
        let size1 = inputSizes[0]
        let size2 = inputSizes[1]
        
        let aspectRatio1 = maxSecondRowHeight / size1.height
        var width1 = size1.width * aspectRatio1
        
        let aspectRatio2 = maxSecondRowHeight / size2.height
        var width2 = size2.width * aspectRatio2
        
        let hRatio = min(maxHorizontalRatio, width1 / width2)
        let ratio1 = hRatio / (1.0 + hRatio)
        
        width1 = (width - hGap) * ratio1
        let height1 = (width1 / size1.width) * size1.height
        
        width2 = width - hGap - width1
        let height2 = (width2 / size2.width) * size2.height
        
        let secondRowHeight = min(maxSecondRowHeight, min(height1, height2))
        
        let rect1 = CGRectMake(0, firstRowHeight + vGap, width1, secondRowHeight)
        let rect2 = CGRectMake(width1 + hGap, firstRowHeight + vGap, width2, secondRowHeight)
        
        height = firstRowHeight + vGap + secondRowHeight
        
        frames = [firstRowRect, rect1, rect2]
    }

    
}
