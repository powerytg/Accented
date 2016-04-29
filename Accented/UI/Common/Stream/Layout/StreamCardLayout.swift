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
    private let leftMargin : CGFloat = 15
    private let rightMargin : CGFloat = 15
    
    var layoutCache : Array<UICollectionViewLayoutAttributes> = []
    
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
        
        calculateLayoutAttributes()
    }
    
    override func collectionViewContentSize() -> CGSize {
        if layoutCache.count == 0 {
            return super.collectionViewContentSize()
        }
        
        var totalHeight : CGFloat = 0
        for attributes in layoutCache {
            totalHeight += attributes.frame.size.height
        }
        
        let w = CGRectGetWidth(UIScreen.mainScreen().bounds)
        totalHeight += CGFloat((layoutCache.count - 1)) * vGap
        
        return CGSizeMake(w, totalHeight)
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
    
    private func calculateLayoutAttributes() -> Void {
        var nextIndex = 0
        let w = CGRectGetWidth(UIScreen.mainScreen().bounds) - leftMargin - rightMargin
        
        let templateCapacity = 2
        var nextY : CGFloat = 0
        var nextItemId = 0
        while nextIndex + templateCapacity < photos.count {
            let photo1 = photos[nextIndex]
            let photo2 = photos[nextIndex + 1]
            let size1 = CGSizeMake(CGFloat(photo1.width), CGFloat(photo1.height))
            let size2 = CGSizeMake(CGFloat(photo2.width), CGFloat(photo2.height))
            let layout = SideBySideTemplate(photoSizes: [size1, size2], maxWidth: w)
            
            for frame in layout.frames {
                let finalRect = CGRectMake(frame.origin.x + leftMargin, frame.origin.y + nextY, frame.size.width, frame.size.height)
                let indexPath = NSIndexPath(forItem: nextItemId, inSection: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = finalRect
                layoutCache.append(attributes)
                
                nextItemId += 1
            }
            
            nextY += layout.height + vGap
            nextIndex += templateCapacity
        }
    }
}
