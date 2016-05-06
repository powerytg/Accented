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
    private var headerHeight : CGFloat = 0
    private let contentStartSection = 1
    
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
    
    private func generateLayoutAttributesForStreamHeader() {
        if fullWidth == 0 {
            fullWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        }
        
        var nextY : CGFloat = 0
        let logoCellSize = CGSizeMake(fullWidth, 110)
        let logoAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: 0, inSection: 0))
        logoAttributes.frame = CGRectMake(0, 0, logoCellSize.width, logoCellSize.height)
        nextY += logoCellSize.height
        
        let navCellSize = CGSizeMake(fullWidth, 35)
        let navAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: 1, inSection: 0))
        navAttributes.frame = CGRectMake(0, nextY, navCellSize.width, navCellSize.height)
        nextY += navCellSize.height

        let buttonsCellSize = CGSizeMake(fullWidth, 100)
        let buttonsAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: 2, inSection: 0))
        buttonsAttributes.frame = CGRectMake(0, nextY, buttonsCellSize.width, buttonsCellSize.height)
        nextY += buttonsCellSize.height
        
        headerHeight = nextY
        layoutCache += [logoAttributes, navAttributes, buttonsAttributes]
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
