//
//  DetailBackgroundView.swift
//  Accented
//
//  Created by Tiangong You on 8/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailBackgroundView: UIImageView {

    // Minimal scroll distance required before the perspective effect would be applied
    fileprivate let minDist : CGFloat = 40
    
    // Maximum scroll distance required for perspective effect to be fully applied
    fileprivate let maxDist : CGFloat = 160
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    fileprivate func initialize() {
        self.clipsToBounds = true
        self.image = UIImage(named: "DarkButterfly")
        self.contentMode = .scaleAspectFill
    }
    
    func applyScrollingAnimation(_ offset : CGPoint) {
        let pos = max(0, offset.y - minDist)
        let percentage = pos / maxDist
        self.alpha = 1 - percentage
    }
}
