//
//  StreamCardLayout.swift
//  Accented
//
//  Created by Tiangong You on 4/28/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamCardLayout: StreamLayoutBase {

    private let vGap : CGFloat = 20
    
    var contentHeight : CGFloat = 0
    var availableWidth : CGFloat = 0
    
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
    
    override func generateLayoutAttributesForTemplates(templates : [StreamLayoutTemplate], sectionStartIndex : Int) -> Void {
        var nextY = contentHeight
        var currentSectionIndex = sectionStartIndex
        for template in templates {
            let headerSize = layoutDelegate!.collectionView!(collectionView!, layout: self, referenceSizeForHeaderInSection: currentSectionIndex)
            
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
            
            currentSectionIndex += 1
            nextY += template.height + vGap
        }
     
        // Update content height
        contentHeight = nextY
    }
}
