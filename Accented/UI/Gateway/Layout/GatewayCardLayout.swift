//
//  GatewayCardLayout.swift
//  Accented
//
//  Created by Tiangong You on 5/2/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class GatewayCardLayout: StreamLayoutBase {
    private let vGap : CGFloat = 20
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareLayout() {
        scrollDirection = .Vertical
        
        if collectionView != nil {
            availableWidth = CGRectGetWidth(collectionView!.bounds) - leftMargin - rightMargin
        }
    }
    
    override func collectionViewContentSize() -> CGSize {
        if layoutCache.count == 0 {
            return super.collectionViewContentSize()
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
    
    override func generateLayoutAttributesForLoadingState() {
        if availableWidth == 0 {
            availableWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        }
        
        let indexPath = NSIndexPath(forItem: 0, inSection: 0)
        let headerSize = layoutDelegate!.collectionView!(collectionView!, layout: self, referenceSizeForHeaderInSection: 0)
        let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: NSIndexPath(forItem: 0, inSection: 0))
        headerAttributes.frame = CGRectMake(0, 0, availableWidth, headerSize.height)
        
        let loadingCellSize = CGSizeMake(availableWidth, 150)
        let loadingCellAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        loadingCellAttributes.frame = CGRectMake(0, headerSize.height, availableWidth, loadingCellSize.height)
        
        contentHeight += headerSize.height + loadingCellSize.height
        layoutCache += [headerAttributes, loadingCellAttributes]
    }
    
    override func generateLayoutAttributesForTemplates(templates : [StreamLayoutTemplate], sectionStartIndex : Int) -> Void {
        var nextY = contentHeight
        var currentSectionIndex = sectionStartIndex
        for template in templates {
            let headerSize = layoutDelegate!.collectionView!(collectionView!, layout: self, referenceSizeForHeaderInSection: currentSectionIndex)
            let footerSize = layoutDelegate!.collectionView!(collectionView!, layout: self, referenceSizeForFooterInSection: currentSectionIndex)
            
            // Header layout
            let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: NSIndexPath(forItem: 0, inSection: currentSectionIndex))
            headerAttributes.frame = CGRectMake(0, nextY, headerSize.width, headerSize.height)
            layoutCache.append(headerAttributes)
            nextY += headerSize.height
            
            // Cell layout
            for (itemIndex, frame) in template.frames.enumerate() {
                let finalRect = CGRectMake(frame.origin.x + leftMargin, frame.origin.y + nextY, frame.size.width, frame.size.height)
                let indexPath = NSIndexPath(forItem: itemIndex, inSection: currentSectionIndex)
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = finalRect
                layoutCache.append(attributes)
            }
            
            nextY += template.height
            
            // Footer layout
            let footerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withIndexPath: NSIndexPath(forItem: 0, inSection: currentSectionIndex))
            footerAttributes.frame = CGRectMake(0, nextY, footerSize.width, footerSize.height)
            layoutCache.append(footerAttributes)
            nextY += footerSize.height + vGap
            
            // Advance to next section
            currentSectionIndex += 1
        }
        
        // Update content height
        contentHeight = nextY
    }
}
