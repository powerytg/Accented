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

class UserSearchResultLayout: UICollectionViewFlowLayout {
    fileprivate let vGap : CGFloat = 20
    fileprivate let itemHeight : CGFloat = 40
    fileprivate let footerHeight : CGFloat = 50
    fileprivate var width : CGFloat
    fileprivate var layoutCache = [String : UICollectionViewLayoutAttributes]()
    fileprivate var contentHeight : CGFloat = 0
    
    init(width : CGFloat) {
        self.width = width
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func prepare() {
        scrollDirection = .vertical
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
    
    fileprivate func generateLayoutAttributesForLoadingState() {
        let indexPath = IndexPath(item : 0, section : 0)
        let nextY = contentHeight
        let loadingCellSize = CGSize(width: width, height: 150)
        let loadingCellAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        loadingCellAttributes.frame = CGRect(x: 0, y: nextY, width: width, height: loadingCellSize.height)
        
        contentHeight += loadingCellSize.height
        layoutCache["loadingCell"] = loadingCellAttributes
    }
    
    func generateLayoutAttributes(startIndex : Int, endIndex : Int) {
        var nextY = contentHeight
        
        for itemIndex in startIndex...endIndex {
            var cacheKey = ""
            
            // Cell layout
            let indexPath = IndexPath(item: itemIndex, section: 0)
            let itemRect = CGRect(x: 0, y: nextY, width: width, height: itemHeight)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = itemRect
            cacheKey = "item_\(itemIndex)"
            layoutCache[cacheKey] = attributes
            nextY += itemHeight
            
            // Footer layout
            let footerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: indexPath)
            footerAttributes.frame = CGRect(x: 0, y: nextY, width: width, height: footerHeight)
            cacheKey = "section_footer_\(itemIndex)"
            layoutCache[cacheKey] = footerAttributes
            nextY += footerHeight + vGap
        }
        
        // Update content height
        contentHeight = nextY
    }
}
