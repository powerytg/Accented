//
//  PhotoGroupStreamLayout.swift
//  Accented
//
//  Generic stream layout in which each collection view section contains a group of photos
//  There're no specific headers or footers in this layout
//
//  Created by You, Tiangong on 5/26/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class PhotoGroupStreamLayout: StreamLayoutBase {
    fileprivate let vGap : CGFloat = 20
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepare() {
        scrollDirection = .vertical
        
        if collectionView != nil {
            fullWidth = collectionView!.bounds.width
        }
    }
    
    override var collectionViewContentSize : CGSize {
        if layoutCache.count == 0 {
            return CGSize.zero
        }
        
        return CGSize(width: availableWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in layoutCache.values {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes.copy() as! UICollectionViewLayoutAttributes)
            }
        }
        
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func generateLayoutAttributesForLoadingState() {
        if fullWidth == 0 {
            fullWidth = UIScreen.main.bounds.width
        }
        
        let indexPath = IndexPath(item : 0, section : 0)
        let nextY = contentHeight
        let loadingCellSize = CGSize(width: availableWidth, height: 150)
        let loadingCellAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        loadingCellAttributes.frame = CGRect(x: 0, y: nextY, width: availableWidth, height: loadingCellSize.height)
        
        contentHeight += loadingCellSize.height
        layoutCache["loadingCell"] = loadingCellAttributes
    }
    
    override func generateLayoutAttributesForTemplates(_ templates : [StreamLayoutTemplate], sectionStartIndex : Int) -> Void {
        // If there's a previous loading indicator, reset its section height to 0
        if let previousLoadingFooterAttrs = layoutCache[loadingIndicatorCacheKey] {
            var f = previousLoadingFooterAttrs.frame
            let loadingIndicatorHeight = f.size.height
            f.size.height = 0
            previousLoadingFooterAttrs.frame = f
            
            // Update content height
            contentHeight -= loadingIndicatorHeight
        }
        
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
            }
            
            // Footer layout
            let isLastSection = (templateIndex == templates.count - 1)
            let footerHeight = isLastSection ? defaultLoadingIndicatorHeight : 0
            var footerCacheKey = isLastSection ? loadingIndicatorCacheKey : "section_footer_\(currentSectionIndex)"
            let indexPath = IndexPath(item: 0, section: currentSectionIndex)
            let footerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: indexPath)
            footerAttributes.frame = CGRect(x: 0, y: nextY, width: fullWidth, height: footerHeight)
            layoutCache[footerCacheKey] = footerAttributes
            nextY += footerHeight + vGap

            // Advance to next section
            nextY += template.height
            currentSectionIndex += 1
        }
        
        // Update content height
        contentHeight = nextY
    }
}
