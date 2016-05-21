//
//  JournalStreamLayout.swift
//  Accented
//
//  Created by You, Tiangong on 5/19/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class JournalStreamLayout: StreamLayoutBase {
    private let vGap : CGFloat = 20
    
    override var leftMargin : CGFloat {
        return 0
    }
    
    override var rightMargin : CGFloat {
        return 0
    }

    // Total height of the header
    private var headerHeight : CGFloat = 260
    private let contentStartSection = 1
    
    override func prepareLayout() {
        scrollDirection = .Vertical
        
        if collectionView != nil {
            fullWidth = CGRectGetWidth(collectionView!.bounds)
        }
    }
    
    override func collectionViewContentSize() -> CGSize {
        if layoutCache.count == 0 {
            return CGSizeZero
        }
        
        return CGSizeMake(availableWidth, contentHeight)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in layoutCache {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        
        return layoutAttributes
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func generateLayoutAttributesForStreamHeader() {
        if fullWidth == 0 {
            fullWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        }
        
        let headerCellSize = CGSizeMake(fullWidth, headerHeight)
        let headerAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: 0, inSection: 0))
        headerAttributes.frame = CGRectMake(0, 0, headerCellSize.width, headerCellSize.height)
        layoutCache.append(headerAttributes)
        contentHeight = headerHeight
    }
    
    override func generateLayoutAttributesForLoadingState() {
        if fullWidth == 0 {
            fullWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        }
        
        // Generate header layout attributes if absent
        if layoutCache.count == 0 {
            generateLayoutAttributesForStreamHeader()
        }
        
        let nextY = contentHeight
        let loadingCellSize = CGSizeMake(availableWidth, 150)
        let loadingCellAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: 0, inSection: contentStartSection))
        loadingCellAttributes.frame = CGRectMake(0, nextY, availableWidth, loadingCellSize.height)
        
        contentHeight += loadingCellSize.height
        layoutCache.append(loadingCellAttributes)
    }
    
    override func generateLayoutAttributesForTemplates(templates : [StreamLayoutTemplate], sectionStartIndex : Int) -> Void {
        // Generate header layout attributes if absent
        if layoutCache.count == 0 {
            generateLayoutAttributesForStreamHeader()
        }
        
        var nextY = contentHeight
        var currentSectionIndex = sectionStartIndex
        for template in templates {
            let frame = template.frames[0]
            let finalRect = CGRectMake(0, frame.origin.y + nextY, availableWidth, frame.size.height)
            let indexPath = NSIndexPath(forItem: 0, inSection: currentSectionIndex)
            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            attributes.frame = finalRect
            layoutCache.append(attributes)
            
            nextY += template.height
            currentSectionIndex += 1
        }
        
        // Update content height
        contentHeight = nextY
    }

}
