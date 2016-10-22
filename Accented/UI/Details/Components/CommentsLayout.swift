//
//  CommentsLayout.swift
//  Accented
//
//  Created by You, Tiangong on 10/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class CommentsLayout: UICollectionViewFlowLayout {

    fileprivate var paddingTop : CGFloat = 80
    fileprivate var leftMargin : CGFloat = 15
    fileprivate var rightMargin : CGFloat = 15
    fileprivate var gap : CGFloat = 10
    fileprivate var availableWidth : CGFloat = 0
    fileprivate var contentHeight : CGFloat = 0
    var comments = [CommentModel]()
    
    // Layout cache
    fileprivate var layoutCache = [String : UICollectionViewLayoutAttributes]()
    
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
            availableWidth = collectionView!.bounds.width - leftMargin - rightMargin
        }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
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
    
    func generateLayoutAttributesIfNeeded() {
        guard comments.count != 0 else { return }
        guard comments.count != layoutCache.count else { return }
        
        var nextY = contentHeight
        for (index, comment) in comments.enumerated() {
            // Ignore if the comment already has a layout
            if layoutCache[cacheKeyForComment(comment)] != nil {
                continue
            }
            
            let measuredSize = CommentRenderer.estimatedSize(comment, width: availableWidth)
            let indexPath = IndexPath(item: index, section: 0)
            let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attrs.frame = CGRect(x: leftMargin, y: nextY, width: measuredSize.width, height: measuredSize.height)
            layoutCache[cacheKeyForComment(comment)] = attrs
            
            nextY += measuredSize.height + gap
        }
        
        contentHeight = nextY
    }
    
    fileprivate func cacheKeyForComment(_ comment : CommentModel) -> String {
        return "comment_\(comment.commentId)"
    }
    
    func clearLayoutCache() {
        contentHeight = 0
        layoutCache.removeAll()
    }
}
