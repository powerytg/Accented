//
//  CommentRenderer.swift
//  Accented
//
//  Created by Tiangong You on 8/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class CommentRenderer: UIView {

    // Data model
    var comment : CommentModel? {
        didSet {
            commentModelDidChange()
        }
    }
    
    // Body label
    var contentLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialize() {
        addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.preferredMaxLayoutWidth = 280
        contentLabel.textColor = UIColor.whiteColor()
        
        // Constraints
        contentLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 10).active = true
        contentLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 10).active = true
    }
    
    private func commentModelDidChange() {
        contentLabel.text = comment?.body
    }
    
    func estimatedHeight(comment : CommentModel, width : CGFloat) -> CGFloat {
        return 40
    }
}
