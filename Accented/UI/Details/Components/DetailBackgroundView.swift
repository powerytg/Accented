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
    private let minDist : CGFloat = 40
    
    // Maximum scroll distance required for perspective effect to be fully applied
    private let maxDist : CGFloat = 160
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    private func initialize() {
        backgroundColor = ThemeManager.sharedInstance.currentTheme.rootViewBackgroundColor
        self.clipsToBounds = true
        self.image = ThemeManager.sharedInstance.currentTheme.backgroundDecorImage
        self.contentMode = .scaleAspectFill
    }
    
    func applyScrollingAnimation(_ offset : CGFloat) {
        let pos = max(0, offset - minDist)
        let percentage = pos / maxDist
        self.alpha = 1 - percentage
    }
}
