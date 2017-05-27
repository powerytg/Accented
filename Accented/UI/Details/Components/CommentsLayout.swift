//
//  CommentsLayout.swift
//  Accented
//
//  Created by You, Tiangong on 10/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

protocol CommentsLayoutDelegate : NSObjectProtocol {
    func cellStyleForItemAtIndexPath(_ indexPath : IndexPath) -> CommentRendererStyle
}

class CommentsLayout: InfiniteLoadingLayout<CommentModel> {

    fileprivate var paddingTop : CGFloat = 80
    fileprivate let darkCellLeftMargin : CGFloat = 50
    fileprivate let lightCelLeftlMargin : CGFloat = 62
    fileprivate var rightMargin : CGFloat = 15
    fileprivate var gap : CGFloat = 10
    fileprivate var availableWidth : CGFloat = 0
    
    // Layout delegate
    weak var delegate : CommentsLayoutDelegate?
    
    override init() {
        super.init()
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func initialize() {
        contentHeight = paddingTop
        scrollDirection = .vertical
    }
    
    override func prepare() {
        if collectionView != nil {
            availableWidth = collectionView!.bounds.width - max(darkCellLeftMargin, lightCelLeftlMargin) - rightMargin
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
    
    override func generateLayoutAttributesIfNeeded() {
        guard collection != nil else { return }

        // If there's a previous loading indicator, reset its section height to 0
        updateCachedLayoutHeight(cacheKey: loadingIndicatorCacheKey, toHeight: 0)
        
        var nextY : CGFloat = paddingTop
        for (index, comment) in collection!.items.enumerated() {
            // Ignore if the comment already has a layout
            let cacheKey = cacheKeyForComment(comment)
            var attrs = layoutCache[cacheKey]
            if attrs == nil {
                let measuredSize = CommentRenderer.estimatedSize(comment, width: availableWidth)
                let indexPath = IndexPath(item: index, section: 0)
                let cellStyle = delegate?.cellStyleForItemAtIndexPath(indexPath)
                var leftMargin : CGFloat = 0
                if let cellStyle = cellStyle {
                    switch cellStyle {
                    case .Dark:
                        leftMargin = darkCellLeftMargin
                    case .Light:
                        leftMargin = lightCelLeftlMargin
                    }
                } else {
                    leftMargin = 0
                }
                
                attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attrs!.frame = CGRect(x: leftMargin, y: nextY, width: measuredSize.width, height: measuredSize.height)
                layoutCache[cacheKeyForComment(comment)] = attrs!
            }
            
            nextY += attrs!.frame.size.height + gap
        }
        
        // Always show the footer regardless of the loading state
        // If not loading, then the footer is simply not visible
        let footerHeight = defaultLoadingIndicatorHeight
        let footerCacheKey = loadingIndicatorCacheKey
        let indexPath = IndexPath(item: 0, section: 0)
        let footerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: indexPath)
        footerAttributes.frame = CGRect(x: 0, y: nextY, width: availableWidth, height: footerHeight)
        layoutCache[footerCacheKey] = footerAttributes
        nextY += footerHeight + gap
        
        contentHeight = nextY
    }
    
    fileprivate func cacheKeyForComment(_ comment : CommentModel) -> String {
        return "comment_\(comment.commentId)"
    }
}
