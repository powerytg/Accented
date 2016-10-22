//
//  DetailCommentCell.swift
//  Accented
//
//  Created by You, Tiangong on 10/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailCommentCell: UICollectionViewCell {
    
    fileprivate let darkCellMargin : CGFloat = 24
    fileprivate let lightCellMargin : CGFloat = 36
    
    var renderer : CommentRenderer!
    
    var comment : CommentModel? {
        didSet {
            renderer.comment = comment
        }
    }
    
    var style : CommentRendererStyle = .Dark
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.clipsToBounds = true
        
        renderer = CommentRenderer(.Dark)
        contentView.addSubview(renderer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        renderer.style = style
        
        var f = renderer.frame
        switch style {
        case .Dark:
            f.origin.x = darkCellMargin
        case .Light:
            f.origin.x = lightCellMargin
        }
        
        f.size.width = contentView.bounds.size.width - f.origin.x
        f.size.height = contentView.bounds.size.height
        renderer.frame = f
    }
}
