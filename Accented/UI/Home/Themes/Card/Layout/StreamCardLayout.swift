//
//  StreamCardLayout.swift
//  Accented
//
//  Created by You, Tiangong on 8/25/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class StreamCardLayout: DefaultStreamLayout {
    
    override init() {
        super.init()
        vGap = 12
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func generateLayoutAttributesForTemplates(_ templates : [StreamLayoutTemplate], sectionStartIndex : Int) -> Void {
        // Generate header layout attributes if absent
        if layoutCache.count == 0 {
            generateLayoutAttributesForStreamHeader()
        }
        
        // If there's a previous loading indicator, reset its section height to 0
        updateCachedLayoutHeight(cacheKey: loadingIndicatorCacheKey, toHeight: 0)
        
        var nextY = contentHeight
        var currentSectionIndex = sectionStartIndex
        for (templateIndex, template) in templates.enumerated() {
            // Cell layout
            for (itemIndex, frame) in template.frames.enumerated() {
                let indexPath = IndexPath(item: itemIndex, section: currentSectionIndex)
                let finalRect = CGRect(x: frame.origin.x + leftMargin, y: frame.origin.y + nextY, width: frame.size.width, height: frame.size.height)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = finalRect
                let cellCacheKey = "photo_\(currentSectionIndex)_\(itemIndex)"
                layoutCache[cellCacheKey] = attributes
                debugPrint(finalRect)
            }
            
            nextY += template.height
            
            // Footer layout
            let isLastSection = (templateIndex == templates.count - 1)
            let footerHeight = isLastSection ? defaultLoadingIndicatorHeight : 0
            let footerCacheKey = isLastSection ? loadingIndicatorCacheKey : "section_footer_\(currentSectionIndex)"
            let indexPath = IndexPath(item: 0, section: currentSectionIndex)
            let footerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: indexPath)
            footerAttributes.frame = CGRect(x: 0, y: nextY, width: fullWidth, height: footerHeight)
            layoutCache[footerCacheKey] = footerAttributes
            nextY += footerHeight + vGap
            
            // Advance to next section
            currentSectionIndex += 1
        }
        
        // Update content height
        contentHeight = nextY
    }
}
