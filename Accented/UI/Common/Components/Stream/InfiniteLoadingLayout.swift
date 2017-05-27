//
//  InfiniteLoadingLayout.swift
//  Accented
//
//  Created by Tiangong You on 5/23/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class InfiniteLoadingLayout<T : ModelBase>: UICollectionViewFlowLayout {
    
    // Loading indicator cachd key
    let loadingIndicatorCacheKey = "loadingIndicator"
    
    // Default infinite loading footer height
    let defaultLoadingIndicatorHeight : CGFloat = 50
    
    // Data model
    var collection : CollectionModel<T>?

    // Content height
    var contentHeight : CGFloat = 0
    
    // Layout cache
    var layoutCache = [String : UICollectionViewLayoutAttributes]()

    func generateLayoutAttributesIfNeeded() {
        // Not implemented in base class
    }
    
    func generateLayoutAttributesForLoadingState() {
        // Not implemented in base class
    }
    
    func clearLayoutCache() {
        contentHeight = 0
        layoutCache.removeAll()
    }
    
    func updateCachedLayoutHeight(cacheKey : String, toHeight : CGFloat) {
        if let cachedAttrs = layoutCache[cacheKey] {
            var f = cachedAttrs.frame
            let previousHeight = f.size.height
            f.size.height = toHeight
            cachedAttrs.frame = f
            
            // Update content height
            contentHeight -= previousHeight
            contentHeight += toHeight
        }
    }
}
