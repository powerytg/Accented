//
//  BlurView.swift
//  Accented
//
//  Created by You, Tiangong on 5/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class BlurView: UIView {

    var blurView : UIVisualEffectView = UIVisualEffectView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    convenience init() {
        self.init(frame : CGRectZero)
        initialize()
    }

    func initialize() {
        let blurEffect = UIBlurEffect(style: .Dark)
        blurView.effect = blurEffect
        blurView.contentView.alpha = 0
        self.addSubview(blurView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.frame = self.bounds
    }
}
