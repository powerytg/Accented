//
//  GatewayCardLayout.swift
//  Accented
//
//  Created by Tiangong You on 5/2/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DefaultStreamLayout: StreamLayoutBase {
    private let vGap : CGFloat = 20
    
    // Total height of the header
    private var headerHeight : CGFloat = 0
    private var navBarHeight : CGFloat = 156
    private let contentStartSection = 1
    
    var navBarDefaultPosition : CGFloat = 0
    var navBarStickyPosition : CGFloat = 0
    
    private var navHeaderAttributes : UICollectionViewLayoutAttributes?
    private var buttonsHeaderAttributes : UICollectionViewLayoutAttributes?
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
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

        // Make the nav bar sticky
        if let navAttributes = self.navHeaderAttributes {
            let contentOffset = collectionView!.contentOffset.y
            if !layoutAttributes.contains(navAttributes) {
                layoutAttributes.append(navAttributes)
            }
            
            var navFrame = navAttributes.frame

            if contentOffset >= (navBarDefaultPosition - navBarStickyPosition) {
                navFrame.origin.y = navBarStickyPosition + contentOffset
            } else {
                navFrame.origin.y = navBarDefaultPosition
            }

            navAttributes.frame = navFrame
            
            // Calculate header compression ratio. Compression starts when the nav bar becomes sticky, and becomes fully compressed
            let compressionStarts : CGFloat = 66
            let compressionCompletes : CGFloat = 106
            headerCompressionRatio = max(0, contentOffset - compressionStarts) / (compressionCompletes - compressionStarts)
            headerCompressionRatio = min(1.0, headerCompressionRatio)
            
            delegate?.streamHeaderCompressionRatioDidChange(headerCompressionRatio)
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
        
        var nextY : CGFloat = 0
        let navCellSize = CGSizeMake(fullWidth, navBarHeight)
        navBarDefaultPosition = nextY
        self.navHeaderAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: 0, inSection: 0))
        self.navHeaderAttributes!.frame = CGRectMake(0, nextY, navCellSize.width, navCellSize.height)
        self.navHeaderAttributes?.zIndex = 1024
        nextY += navCellSize.height

        let buttonsCellSize = CGSizeMake(fullWidth, 110)
        self.buttonsHeaderAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: 1, inSection: 0))
        self.buttonsHeaderAttributes!.frame = CGRectMake(0, nextY, buttonsCellSize.width, buttonsCellSize.height)
        nextY += buttonsCellSize.height
        
        headerHeight = nextY
        layoutCache += [self.navHeaderAttributes!, self.buttonsHeaderAttributes!]
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
