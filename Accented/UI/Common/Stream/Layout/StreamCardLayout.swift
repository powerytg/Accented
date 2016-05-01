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
    
    // A cache that holds all the previously calculated layout attributes. The cache will remain valid until
    // explicitly cleared
    var layoutCache : Array<UICollectionViewLayoutAttributes> = []
    
    // Cached templates to be synced with layout generator
    var templateCache = [StreamLayoutTemplate]()
    
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
        
        if photos.count == 0 {
            return
        }
        
        if collectionView != nil {
            availableWidth = CGRectGetWidth(collectionView!.bounds) - leftMargin - rightMargin
        }
        
        syncLayoutAttributesWithLayoutGenerator()
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
    
    private func syncLayoutAttributesWithLayoutGenerator() -> Void {
        if layoutCache.count >= photos.count {
            return
        }
        
        guard layoutGenerator != nil else {
            return
        }
        
        if templateCache.count == layoutGenerator?.templates.count {
            return
        }
        
        let sectionStartIndex = templateCache.count
        let sectionEndIndex = layoutGenerator!.templates.count - 1
        templateCache = layoutGenerator!.templates
        let templatesForProcessing = Array(templateCache[sectionStartIndex...sectionEndIndex])
        let sectionHeight = headerReferenceSize.height
        
        var nextY = contentHeight
        var nextSectionIndex = sectionStartIndex
        for template in templatesForProcessing {
            for (itemIndex, frame) in template.frames.enumerate() {
                let finalRect = CGRectMake(frame.origin.x + leftMargin, frame.origin.y + nextY, frame.size.width, frame.size.height)
                let indexPath = NSIndexPath(forItem: itemIndex, inSection: nextSectionIndex)
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = finalRect
                layoutCache.append(attributes)
            }
            
            nextSectionIndex += 1
            nextY += template.height + vGap + sectionHeight
        }
     
        // Update content height
        contentHeight = nextY
    }
}
