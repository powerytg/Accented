//
//  StreamCardLayout.swift
//  Accented
//
//  Created by You, Tiangong on 8/25/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class StreamCardLayout: DefaultStreamLayout {
    override func generateLayoutAttributesForTemplates(_ templates : [StreamLayoutTemplate], sectionStartIndex : Int) -> Void {
        // Generate header layout attributes if absent
        if layoutCache.count == 0 {
            generateLayoutAttributesForStreamHeader()
        }
        
        var nextY = contentHeight
        var currentSectionIndex = sectionStartIndex
        for template in templates {
            let frame = template.frames[0]
            let finalRect = CGRect(x: 0, y: frame.origin.y + nextY, width: availableWidth, height: frame.size.height)
            let indexPath = IndexPath(item: 0, section: currentSectionIndex)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = finalRect
            let cacheKey = "cell_\(currentSectionIndex)"
            layoutCache[cacheKey] = attributes
            
            nextY += template.height
            currentSectionIndex += 1
        }
        
        // Update content height
        contentHeight = nextY
    }
}
