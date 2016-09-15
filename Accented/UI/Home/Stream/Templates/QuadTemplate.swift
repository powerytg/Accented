//
//  QuadTemplate.swift
//  Accented
//
//  Created by Tiangong You on 5/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class QuadTemplate: StreamLayoutTemplateBase {

    fileprivate let maxRowHeight : CGFloat = 200
    fileprivate let maxHorizontalRatio : CGFloat = 3.0 / 2.0
    
    override var capacity : Int {
        return 4
    }
    
    required init(photoSizes: Array<CGSize>, maxWidth: CGFloat) {
        super.init(photoSizes: photoSizes, maxWidth: maxWidth)
        let rowHeight1 = generateLayoutMetadataForRow(inputSizes[0], size2: inputSizes[1], startY: 0)
        let rowHeight2 = generateLayoutMetadataForRow(inputSizes[2], size2: inputSizes[3], startY: rowHeight1 + vGap)
        
        height = rowHeight1 + vGap + rowHeight2
    }
    
    fileprivate func generateLayoutMetadataForRow(_ size1 : CGSize, size2 : CGSize, startY : CGFloat) -> CGFloat {
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
        
        let rect1 = CGRect(x: 0, y: startY, width: width1, height: rowHeight)
        let rect2 = CGRect(x: width1 + hGap, y: startY, width: width2, height: rowHeight)
        
        frames += [rect1, rect2]
        
        return rowHeight
    }
    
}
