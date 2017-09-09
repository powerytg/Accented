//
//  UserGalleryListLayout.swift
//  Accented
//
//  Created by You, Tiangong on 9/6/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserGalleryListLayout: InfiniteLoadingLayout<GalleryModel> {
    
    private var paddingTop : CGFloat = 80
    private var paddingLeft : CGFloat = 15
    private var paddingRight : CGFloat = 15
    private var hGap : CGFloat = 10
    private var vGap : CGFloat = 10
    private var availableWidth : CGFloat = 0
    private var headerHeight : CGFloat = 210
    
    override init() {
        super.init()
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        contentHeight = paddingTop
        scrollDirection = .vertical
    }
    
    override func prepare() {
        if collectionView != nil {
            availableWidth = collectionView!.bounds.width - paddingLeft - paddingRight
        }
    }
    
    override var collectionViewContentSize : CGSize {
        generateLayoutAttributesIfNeeded()
        guard layoutCache.count != 0 else {
            return CGSize.zero
        }
        
        return CGSize(width: availableWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        generateLayoutAttributesIfNeeded()
        guard layoutCache.count != 0 else { return nil }
        
        for attributes in layoutCache.values {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes.copy() as! UICollectionViewLayoutAttributes)
            }
        }
        
        return layoutAttributes
    }
    
    private func generateLayoutAttributesForStreamHeader() {
        if availableWidth == 0 {
            availableWidth = UIScreen.main.bounds.width
        }
        
        // Stream header
        let indexPath = IndexPath(item : 0, section : 0)
        let headerCellSize = CGSize(width: availableWidth, height: headerHeight)
        let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attrs.frame = CGRect(x: 0, y: 0, width: headerCellSize.width, height: headerCellSize.height)
        layoutCache["streamHeader"] = attrs
        contentHeight = headerHeight
    }

    override func generateLayoutAttributesForLoadingState() {
        if availableWidth == 0 {
            availableWidth = UIScreen.main.bounds.width
        }
        
        let indexPath = IndexPath(item : 0, section : 0)
        let nextY = contentHeight
        let loadingCellSize = CGSize(width: availableWidth, height: 150)
        let loadingCellAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        loadingCellAttributes.frame = CGRect(x: 0, y: nextY, width: availableWidth, height: loadingCellSize.height)
        
        contentHeight += loadingCellSize.height
        layoutCache["loadingCell"] = loadingCellAttributes
    }

    override func generateLayoutAttributesIfNeeded() {
        guard collection != nil else { return }
        
        // Generate header layout attributes if absent
        if layoutCache.count == 0 {
            generateLayoutAttributesForStreamHeader()
        }

        // If there's a previous loading indicator, reset its section height to 0
        updateCachedLayoutHeight(cacheKey: loadingIndicatorCacheKey, toHeight: 0)
        
        let galleryWidth = (availableWidth - hGap) / 2
        let galleryHeight = galleryWidth + 15
        var nextY : CGFloat = headerHeight
        for (index, gallery) in collection!.items.enumerated() {
            // Ignore if the cell already has a layout
            let cacheKey = cacheKeyForGallery(gallery)
            var attrs = layoutCache[cacheKey]
            if attrs == nil {
                let indexPath = IndexPath(item: index, section: 1)
                let left : CGFloat = (index % 2 == 0) ? paddingLeft : (paddingLeft + galleryWidth + hGap)
                
                attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attrs!.frame = CGRect(x: left, y: nextY, width: galleryWidth, height: galleryHeight)
                layoutCache[cacheKeyForGallery(gallery)] = attrs!
            }
            
            if index % 2 == 1 {
                nextY += galleryHeight + vGap
            }
        }
        
        // Always show the footer regardless of the loading state
        // If not loading, then the footer is simply not visible
        let footerHeight = defaultLoadingIndicatorHeight
        let footerCacheKey = loadingIndicatorCacheKey
        let indexPath = IndexPath(item: 0, section: 1)
        let footerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: indexPath)
        footerAttributes.frame = CGRect(x: 0, y: nextY, width: availableWidth, height: footerHeight)
        layoutCache[footerCacheKey] = footerAttributes
        nextY += footerHeight + vGap
        
        contentHeight = nextY
    }
    
    private func cacheKeyForGallery(_ gallery : GalleryModel) -> String {
        return "gallery_\(gallery.galleryId)"
    }
}
