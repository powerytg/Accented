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
    private let backdropFadeTimingFactor : CGFloat = 0.5
    
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
        
        if collectionView != nil {
            let sectionCount = self.collectionView!.numberOfSections()
            
            // Backdrop layout attributes
            let contentOffset = collectionView!.contentOffset.y
            let screenHeight = CGRectGetHeight(UIScreen.mainScreen().bounds)
            
            // Backdrop starts from the first photo
            let backdropPositionY = max(contentOffset, headerHeight)
            let backdropFrame = CGRectMake(0, backdropPositionY, fullWidth, screenHeight)
            
            // As the content scrolls, fade out the backdrop
            let backdropMaxFadeDist: CGFloat = headerHeight * backdropFadeTimingFactor
            var backdropAlpha = (backdropMaxFadeDist - contentOffset) / backdropMaxFadeDist
            if backdropAlpha < 0 {
                backdropAlpha = 0
            } else if backdropAlpha > 1 {
                backdropAlpha = 1
            }
            
            // Only apply the backdrop or bubble decorations when there are more than one section (the first section is always the header)
            if(sectionCount > contentStartSection) {
                let backdropAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: JournalViewModel.backdropDecorIdentifier, withIndexPath: NSIndexPath(forItem: 0, inSection: contentStartSection))
                backdropAttributes.frame = backdropFrame
                backdropAttributes.alpha = backdropAlpha
                backdropAttributes.zIndex = -2
                layoutAttributes.append(backdropAttributes)
                
                // Bubble footer decoration
                let bubbleWidth : CGFloat = 127
                let bubbleHeight : CGFloat = 141
                let bubblePositionY = contentOffset + screenHeight - bubbleHeight
                let bubbleFrame = CGRectMake(0, bubblePositionY, bubbleWidth, bubbleHeight)
                let bubbleAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: JournalViewModel.bubbleDecorIdentifier, withIndexPath: NSIndexPath(forItem: 0, inSection: contentStartSection))
                bubbleAttributes.frame = bubbleFrame
                bubbleAttributes.zIndex = -1
                layoutAttributes.append(bubbleAttributes)   
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
