//
//  GatewayCardLayout.swift
//  Accented
//
//  Home stream layout for the default theme
//  In this layout, photos are organized into groups, and the group footer lists  the names of the photographers
//
//  Created by Tiangong You on 5/2/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DefaultStreamLayout: StreamLayoutBase {
    let vGap : CGFloat = 20
    
    // Total height of the header
    private var headerHeight : CGFloat = 0
    private var navBarHeight : CGFloat = 156
    private let contentStartSection = 1
    
    var navBarDefaultPosition : CGFloat = 0
    var navBarStickyPosition : CGFloat = 0
    var streamSelectorDefaultPosition : CGFloat = 0
    
    private var navHeaderAttributes : UICollectionViewLayoutAttributes?
    private var buttonsHeaderAttributes : UICollectionViewLayoutAttributes?
    
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
        let contentOffset = collectionView!.contentOffset.y
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in layoutCache.values {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes.copy() as! UICollectionViewLayoutAttributes)
            }
        }

        // Make the nav bar sticky
        if let navAttributes = self.navHeaderAttributes {
            if !layoutAttributes.contains(navAttributes) {
                layoutAttributes.append(navAttributes)
            }
            
            layoutHeaderCell(contentOffset)
        }
        
        
        return layoutAttributes
    }
    
    private func layoutHeaderCell(_ contentOffset : CGFloat) {
        var navFrame = navHeaderAttributes!.frame
        
        if contentOffset >= (navBarDefaultPosition - navBarStickyPosition) {
            navFrame.origin.y = navBarStickyPosition + contentOffset
        } else {
            navFrame.origin.y = navBarDefaultPosition
        }
        
        navHeaderAttributes!.frame = navFrame
        
        // Calculate header compression ratio. Compression starts when the nav bar becomes sticky, and becomes fully compressed
        let compressionStarts : CGFloat = 66
        let compressionCompletes : CGFloat = 106
        headerCompressionRatio = max(0, contentOffset - compressionStarts) / (compressionCompletes - compressionStarts)
        headerCompressionRatio = min(1.0, headerCompressionRatio)
        
        delegate?.streamHeaderCompressionRatioDidChange(headerCompressionRatio)
    }
    
    private func layoutSelectorCell(_ contentOffset : CGFloat) {
        var selectorFrame = buttonsHeaderAttributes!.frame
        if contentOffset < 0 {
            selectorFrame.origin.y = streamSelectorDefaultPosition + contentOffset
            buttonsHeaderAttributes!.frame = selectorFrame
        } else {
            selectorFrame.origin.y = streamSelectorDefaultPosition
            buttonsHeaderAttributes!.frame = selectorFrame
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func generateLayoutAttributesForStreamHeader() {
        if fullWidth == 0 {
            fullWidth = UIScreen.main.bounds.width
        }
        
        // Header
        var indexPath = IndexPath(item : 0, section : 0)
        var nextY : CGFloat = 0
        let navCellSize = CGSize(width: fullWidth, height: navBarHeight)
        navBarDefaultPosition = nextY
        self.navHeaderAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        self.navHeaderAttributes!.frame = CGRect(x: 0, y: nextY, width: navCellSize.width, height: navCellSize.height)
        self.navHeaderAttributes?.zIndex = 1024
        layoutCache["navHeader"] = navHeaderAttributes
        nextY += navCellSize.height

        // Selector
        indexPath = IndexPath(item : 1, section : 0)
        streamSelectorDefaultPosition = nextY
        let buttonsCellSize = CGSize(width: fullWidth, height: 110)
        self.buttonsHeaderAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        self.buttonsHeaderAttributes!.frame = CGRect(x: 0, y: nextY, width: buttonsCellSize.width, height: buttonsCellSize.height)
        layoutCache["navSelector"] = buttonsHeaderAttributes
        nextY += buttonsCellSize.height
        
        headerHeight = nextY
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
        
        let indexPath = IndexPath(item : 0, section : contentStartSection)
        let nextY = contentHeight
        let loadingCellSize = CGSize(width: availableWidth, height: 150)
        let loadingCellAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        loadingCellAttributes.frame = CGRect(x: 0, y: nextY, width: availableWidth, height: loadingCellSize.height)
        
        contentHeight += loadingCellSize.height
        layoutCache["loadingCell"] = loadingCellAttributes
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
            var cacheKey = ""
            
            // Header layout
            var indexPath = IndexPath(item: 0, section: currentSectionIndex)
            let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
            headerAttributes.frame = CGRect(x: 0, y: nextY, width: headerSize.width, height: headerSize.height)
            cacheKey = "section_header_\(currentSectionIndex)"
            layoutCache[cacheKey] = headerAttributes
            nextY += headerSize.height
            
            // Cell layout
            for (itemIndex, frame) in template.frames.enumerated() {
                indexPath = IndexPath(item: itemIndex, section: currentSectionIndex)
                let finalRect = CGRect(x: frame.origin.x + leftMargin, y: frame.origin.y + nextY, width: frame.size.width, height: frame.size.height)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = finalRect
                cacheKey = "photo_\(currentSectionIndex)_\(itemIndex)"
                layoutCache[cacheKey] = attributes
            }
            
            nextY += template.height
            
            // Footer layout
            indexPath = IndexPath(item: 0, section: currentSectionIndex)
            let footerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: indexPath)
            footerAttributes.frame = CGRect(x: 0, y: nextY, width: footerSize.width, height: footerSize.height)
            cacheKey = "section_footer_\(currentSectionIndex)"
            layoutCache[cacheKey] = footerAttributes
            nextY += footerSize.height + vGap
            
            // Advance to next section
            currentSectionIndex += 1
        }
        
        // Update content height
        contentHeight = nextY
    }
}
