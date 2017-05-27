//
//  UserSearchResultLayout.swift
//  Accented
//
//  User search result layout
//
//  Created by Tiangong You on 5/22/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserSearchResultLayout: InfiniteLoadingLayout<UserModel> {
    fileprivate let vGap : CGFloat = 8
    fileprivate let itemHeight : CGFloat = 60
    fileprivate let footerHeight : CGFloat = 50
    fileprivate var width : CGFloat = 0
    fileprivate let leftMargin : CGFloat = 15
    fileprivate let rightMargin : CGFloat = 15
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func prepare() {
        scrollDirection = .vertical
        
        if collectionView != nil {
            width = collectionView!.bounds.width
        }
    }
    
    override var collectionViewContentSize : CGSize {
        return CGSize(width: width, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in layoutCache.values {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes.copy() as! UICollectionViewLayoutAttributes)
            }
        }
        
        return layoutAttributes
    }
    
    override func generateLayoutAttributesIfNeeded() {
        guard collection != nil else { return }
        
        // If there's a previous loading indicator, reset its section height to 0
        updateCachedLayoutHeight(cacheKey: loadingIndicatorCacheKey, toHeight: 0)

        var nextY : CGFloat = 0
        for (index, user) in collection!.items.enumerated() {
            // Ignore if the user already has a layout
            let cacheKey = cacheKeyForUser(user)
            var attrs = layoutCache[cacheKey]
            if attrs == nil {
                let cellSize = CGSize(width: width - leftMargin - rightMargin, height: itemHeight)
                let indexPath = IndexPath(item: index, section: 0)
                attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attrs!.frame = CGRect(x: leftMargin, y: nextY, width: cellSize.width, height: cellSize.height)
                layoutCache[cacheKey] = attrs!
            }
            
            nextY += attrs!.frame.size.height + vGap
        }
        
        // Always show the footer regardless of the loading state
        // If not loading, then the footer is simply not visible
        let footerHeight = defaultLoadingIndicatorHeight
        let footerCacheKey = loadingIndicatorCacheKey
        let indexPath = IndexPath(item: 0, section: 0)
        let footerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: indexPath)
        footerAttributes.frame = CGRect(x: 0, y: nextY, width: width, height: footerHeight)
        layoutCache[footerCacheKey] = footerAttributes
        nextY += footerHeight + vGap
        
        contentHeight = nextY
    }
    
    fileprivate func cacheKeyForUser(_ user : UserModel) -> String {
        return "user_\(user.userId)"
    }

}
