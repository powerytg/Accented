//
//  QuadTemplate.swift
//  Accented
//
//  Created by Tiangong You on 5/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class QuadTemplate: StreamLayoutTemplateBase {

    private let maxRowHeight : CGFloat = 200
    private let maxHorizontalRatio : CGFloat = 3.0 / 2.0
    
    override var capacity : Int {
        return 4
    }
    
    required init(photoSizes: Array<CGSize>, maxWidth: CGFloat) {
        super.init(photoSizes: photoSizes, maxWidth: maxWidth)
        let rowHeight1 = generateLayoutMetadataForRow(inputSizes[0], size2: inputSizes[1], startY: 0)
        let rowHeight2 = generateLayoutMetadataForRow(inputSizes[2], size2: inputSizes[3], startY: rowHeight1 + vGap)
        
        height = rowHeight1 + vGap + rowHeight2
    }
    
    private func generateLayoutMetadataForRow(size1 : CGSize, size2 : CGSize, startY : CGFloat) -> CGFloat {
        let size1 = inputSizes[0]
        let size2 = inputSizes[1]
        
        let aspectRatio1 = maxRowHeight / size1.height
        var width1 = size1.width * aspectRatio1
        
        let aspectRatio2 = maxRowHeight / size2.height
        var width2 = size2.width * aspectRatio2
        
        let hRatio = min(maxHorizontalRatio, width1 / width2)
        let ratio1 = hRatio / (1.0 + hRatio)
        
        width1 = (width - hGap) * ratio1
        let height1 = (width1 / size1.width) * size1.height
        
        width2 = width - hGap - width1
        let height2 = (width2 / size2.width) * size2.height
        
        let rowHeight = min(maxRowHeight, min(height1, height2))
        
        let rect1 = CGRectMake(0, startY, width1, rowHeight)
        let rect2 = CGRectMake(width1 + hGap, startY, width2, rowHeight)
        
        frames += [rect1, rect2]
        
        return rowHeight
    }
    
}
