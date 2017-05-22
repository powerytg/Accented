//
//  PhotoSearchResultLayout.swift
//  Accented
//
//  Created by Tiangong You on 5/21/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class PhotoSearchResultLayout: StreamLayoutBase {
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
        var nextY = contentHeight
        var currentSectionIndex = sectionStartIndex
        for template in templates {
            let headerSize = layoutDelegate!.collectionView!(collectionView!, layout: self, referenceSizeForHeaderInSection: currentSectionIndex)
            let footerSize = layoutDelegate!.collectionView!(collectionView!, layout: self, referenceSizeForFooterInSection: currentSectionIndex)
            var cacheKey = ""
            
            // Header layout
            var indexPath = IndexPath(item: 0, section: currentSectionIndex)
            let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
            headerAttributes.frame = CGRect(x: 0, y: nextY, width: headerSize.width, height: headerSize.height)
            cacheKey = "section_header_\(currentSectionIndex)"
            layoutCache[cacheKey] = headerAttributes
            nextY += headerSize.height
            
            // Cell layout
            for (itemIndex, frame) in template.frames.enumerated() {
                indexPath = IndexPath(item: itemIndex, section: currentSectionIndex)
                let finalRect = CGRect(x: frame.origin.x + leftMargin, y: frame.origin.y + nextY, width: frame.size.width, height: frame.size.height)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = finalRect
                cacheKey = "photo_\(currentSectionIndex)_\(itemIndex)"
                layoutCache[cacheKey] = attributes
            }
            
            nextY += template.height
            
            // Footer layout
            indexPath = IndexPath(item: 0, section: currentSectionIndex)
            let footerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: indexPath)
            footerAttributes.frame = CGRect(x: 0, y: nextY, width: footerSize.width, height: footerSize.height)
            cacheKey = "section_footer_\(currentSectionIndex)"
            layoutCache[cacheKey] = footerAttributes
            nextY += footerSize.height + vGap
            
            // Advance to next section
            currentSectionIndex += 1
        }
        
        // Update content height
        contentHeight = nextY
    }
}
