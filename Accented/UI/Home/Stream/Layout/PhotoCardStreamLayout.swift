//
//  PhotoCardStreamLayout.swift
//  Accented
//
//  Generic photo card style layout
//  This layout has no particular headers or footers
//
//  Created by You, Tiangong on 5/19/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class PhotoCardStreamLayout: StreamLayoutBase {
    private let vGap : CGFloat = 20

    override var leftMargin : CGFloat {
        return 25
    }
    
    override var rightMargin : CGFloat {
        return 25
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
                layoutAttributes.append(attributes)
            }
        }
        
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func generateLayoutAttributesForStreamHeader() {
        // Base class has no header
    }
    
    override func generateLayoutAttributesForLoadingState() {
        if fullWidth == 0 {
            fullWidth = UIScreen.main.bounds.width
        }
        
        // Generate header layout attributes if absent
        if layoutCache.count == 0 {
            generateLayoutAttributesForStreamHeader()
        }
        
        let nextY = contentHeight
        let indexPath = IndexPath(item: 0, section: 0)
        let loadingCellSize = CGSize(width: availableWidth, height: 150)
        let loadingCellAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        loadingCellAttributes.frame = CGRect(x: 0, y: nextY, width: availableWidth, height: loadingCellSize.height)
        
        contentHeight += loadingCellSize.height
        layoutCache["loadingCell"] = loadingCellAttributes
    }
    
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
