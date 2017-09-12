//
//  BlurView.swift
//  Accented
//
//  Created by You, Tiangong on 5/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class BlurView: UIView {

    var blurView : UIVisualEffectView!
    
    var blurEffect : UIBlurEffect? {
        didSet {
            blurView.effect = blurEffect
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    func initialize() {
        let effect = ThemeManager.sharedInstance.currentTheme.backgroundBlurEffect
        blurView = UIVisualEffectView(effect: effect)
        self.addSubview(blurView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.frame = self.bounds
    }
}
