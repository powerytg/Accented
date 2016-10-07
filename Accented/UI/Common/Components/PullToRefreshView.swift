//
//  PullToRefreshView.swift
//  Accented
//
//  Created by You, Tiangong on 10/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class PullToRefreshView: UIView {

    fileprivate var label = UILabel()
    var percentage : CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    fileprivate func initialize() {
        addSubview(label)
        label.text = "Pull down to refresh"
        label.alpha = 0
        label.sizeToFit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var f = label.frame
        f.origin.x = self.bounds.size.width / 2 - f.size.width / 2
        f.origin.y = self.bounds.size.height / 2 - f.size.height / 2
        label.frame = f
        
        label.alpha = max(0, min(1.0, percentage))
    }
}
