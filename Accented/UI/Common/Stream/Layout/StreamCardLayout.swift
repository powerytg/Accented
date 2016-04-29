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
    
    // A cache that holds all the previously calculated layout attributes. The cache will remain valid until
    // explicitly cleared
    var layoutCache : Array<UICollectionViewLayoutAttributes> = []
    
    // Layout template generator that takes in a group of image sizes and returns calculated frames for the images
    var templateGenerator : TemplateGenerator?
    
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
        
        calculateLayoutAttributes()
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
    
    private func calculateLayoutAttributes() -> Void {
        if availableWidth == 0 || layoutCache.count >= photos.count {
            return
        }
        
        if templateGenerator == nil {
            templateGenerator = TemplateGenerator(maxWidth: availableWidth)
        }
        
        // Start from the index that has no layout yet
        let startIndex = layoutCache.count
        let endIndex = photos.count - 1
        let photosForProcessing = photos[startIndex...endIndex]
        templateGenerator?.photos = Array(photosForProcessing)
        
        let templates = templateGenerator?.generateLayoutTemplates()
        if templates == nil || templates?.count == 0 {
            return
        }
        
        var nextY = contentHeight
        var nextIndex = startIndex
        for template in templates! {
            for frame in template.frames {
                let finalRect = CGRectMake(frame.origin.x + leftMargin, frame.origin.y + nextY, frame.size.width, frame.size.height)
                let indexPath = NSIndexPath(forItem: nextIndex, inSection: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = finalRect
                layoutCache.append(attributes)
                nextIndex += 1
            }
            
            nextY += template.height + vGap
        }
     
        // Update content height
        contentHeight = nextY
    }
}
