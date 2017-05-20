//
//  DetailCommentCell.swift
//  Accented
//
//  Created by You, Tiangong on 10/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailCommentCell: UICollectionViewCell {
    
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
        renderer.frame = contentView.bounds
    }
}
