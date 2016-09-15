//
//  GatewayCardLayout.swift
//  Accented
//
//  Created by Tiangong You on 5/2/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DefaultStreamLayout: StreamLayoutBase {
    fileprivate let vGap : CGFloat = 20
    
    // Total height of the header
    fileprivate var headerHeight : CGFloat = 0
    fileprivate var navBarHeight : CGFloat = 156
    fileprivate let contentStartSection = 1
    
    var navBarDefaultPosition : CGFloat = 0
    var navBarStickyPosition : CGFloat = 0
    
    fileprivate var navHeaderAttributes : UICollectionViewLayoutAttributes?
    fileprivate var buttonsHeaderAttributes : UICollectionViewLayoutAttributes?
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        
        for attributes in layoutCache {
            if attributes.frame.intersects(rect) {
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
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func generateLayoutAttributesForStreamHeader() {
        if fullWidth == 0 {
            fullWidth = UIScreen.main.bounds.width
        }
        
        var nextY : CGFloat = 0
        let navCellSize = CGSize(width: fullWidth, height: navBarHeight)
        navBarDefaultPosition = nextY
        self.navHeaderAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: 0, section: 0))
        self.navHeaderAttributes!.frame = CGRect(x: 0, y: nextY, width: navCellSize.width, height: navCellSize.height)
        self.navHeaderAttributes?.zIndex = 1024
        nextY += navCellSize.height

        let buttonsCellSize = CGSize(width: fullWidth, height: 110)
        self.buttonsHeaderAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: 1, section: 0))
        self.buttonsHeaderAttributes!.frame = CGRect(x: 0, y: nextY, width: buttonsCellSize.width, height: buttonsCellSize.height)
        nextY += buttonsCellSize.height
        
        headerHeight = nextY
        layoutCache += [self.navHeaderAttributes!, self.buttonsHeaderAttributes!]
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
            let headerSize = layoutDelegate!.collectionView!(collectionView!, layout: self, referenceSizeForHeaderInSection: currentSectionIndex)
            let footerSize = layoutDelegate!.collectionView!(collectionView!, layout: self, referenceSizeForFooterInSection: currentSectionIndex)
            
            // Header layout
            let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: IndexPath(item: 0, section: currentSectionIndex))
            headerAttributes.frame = CGRect(x: 0, y: nextY, width: headerSize.width, height: headerSize.height)
            layoutCache.append(headerAttributes)
            nextY += headerSize.height
            
            // Cell layout
            for (itemIndex, frame) in template.frames.enumerated() {
                let finalRect = CGRect(x: frame.origin.x + leftMargin, y: frame.origin.y + nextY, width: frame.size.width, height: frame.size.height)
                let indexPath = IndexPath(item: itemIndex, section: currentSectionIndex)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = finalRect
                layoutCache.append(attributes)
            }
            
            nextY += template.height
            
            // Footer layout
            let footerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: IndexPath(item: 0, section: currentSectionIndex))
            footerAttributes.frame = CGRect(x: 0, y: nextY, width: footerSize.width, height: footerSize.height)
            layoutCache.append(footerAttributes)
            nextY += footerSize.height + vGap
            
            // Advance to next section
            currentSectionIndex += 1
        }
        
        // Update content height
        contentHeight = nextY
    }
}
