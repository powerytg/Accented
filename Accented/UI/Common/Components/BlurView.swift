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
    
    var blurEffect : UIBlurEffect {
        didSet {
            blurView.effect = blurEffect
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        blurEffect = ThemeManager.sharedInstance.currentTheme.backgroundBlurEffect
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        blurEffect = ThemeManager.sharedInstance.currentTheme.backgroundBlurEffect
        super.init(frame: frame)
        initialize()
    }
    
    convenience init() {
        self.init(frame : CGRect.zero)
        initialize()
    }

    func initialize() {
        blurView.contentView.alpha = 0
        self.addSubview(blurView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.frame = self.bounds
    }
}
