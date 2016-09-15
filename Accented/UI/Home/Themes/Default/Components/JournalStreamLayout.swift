//
//  JournalStreamLayout.swift
//  Accented
//
//  Created by You, Tiangong on 5/19/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class JournalStreamLayout: StreamLayoutBase {
    fileprivate let vGap : CGFloat = 20
    fileprivate let backdropFadeTimingFactor : CGFloat = 0.5
    
    override var leftMargin : CGFloat {
        return 0
    }
    
    override var rightMargin : CGFloat {
        return 0
    }

    // Total height of the header
    fileprivate var headerHeight : CGFloat = 260
    fileprivate let contentStartSection = 1
    
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
        
        for attributes in layoutCache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        
        if collectionView != nil {
            let sectionCount = self.collectionView!.numberOfSections
            
            // Backdrop layout attributes
            let contentOffset = collectionView!.contentOffset.y
            let screenHeight = UIScreen.main.bounds.height
            
            // Backdrop starts from the first photo
            let backdropPositionY = max(contentOffset, headerHeight)
            let backdropFrame = CGRect(x: 0, y: backdropPositionY, width: fullWidth, height: screenHeight)
            
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
                let backdropAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: JournalViewModel.backdropDecorIdentifier, with: IndexPath(item: 0, section: contentStartSection))
                backdropAttributes.frame = backdropFrame
                backdropAttributes.alpha = backdropAlpha
                backdropAttributes.zIndex = -2
                layoutAttributes.append(backdropAttributes)
                
                // Bubble footer decoration
                let bubbleWidth : CGFloat = 127
                let bubbleHeight : CGFloat = 141
                let bubblePositionY = contentOffset + screenHeight - bubbleHeight
                let bubbleFrame = CGRect(x: 0, y: bubblePositionY, width: bubbleWidth, height: bubbleHeight)
                let bubbleAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: JournalViewModel.bubbleDecorIdentifier, with: IndexPath(item: 0, section: contentStartSection))
                bubbleAttributes.frame = bubbleFrame
                bubbleAttributes.zIndex = -1
                layoutAttributes.append(bubbleAttributes)   
            }
        }
    
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func generateLayoutAttributesForStreamHeader() {
        if fullWidth == 0 {
            fullWidth = UIScreen.main.bounds.width
        }
        
        let headerCellSize = CGSize(width: fullWidth, height: headerHeight)
        let headerAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: 0, section: 0))
        headerAttributes.frame = CGRect(x: 0, y: 0, width: headerCellSize.width, height: headerCellSize.height)
        layoutCache.append(headerAttributes)
        contentHeight = headerHeight
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
        let loadingCellSize = CGSize(width: availableWidth, height: 150)
        let loadingCellAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: 0, section: contentStartSection))
        loadingCellAttributes.frame = CGRect(x: 0, y: nextY, width: availableWidth, height: loadingCellSize.height)
        
        contentHeight += loadingCellSize.height
        layoutCache.append(loadingCellAttributes)
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
            layoutCache.append(attributes)
            
            nextY += template.height
            currentSectionIndex += 1
        }
        
        // Update content height
        contentHeight = nextY
    }

}
