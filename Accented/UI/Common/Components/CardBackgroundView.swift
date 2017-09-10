//
//  CardBackgroundView.swift
//  Accented
//
//  Created by Tiangong You on 9/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class CardBackgroundView: ThemeableBackgroundView {
    // Minimal scroll distance required before the perspective effect would be applied
    private let minDist : CGFloat = 40
    
    // Maximum scroll distance required for perspective effect to be fully applied
    private let maxDist : CGFloat = 160

    private var imageView = UIImageView()
    
    override func initialize() {
        super.initialize()
        backgroundColor = ThemeManager.sharedInstance.currentTheme.rootViewBackgroundColor
        self.clipsToBounds = true
        
        addSubview(imageView)
        imageView.image = ThemeManager.sharedInstance.currentTheme.backgroundDecorImage
        imageView.contentMode = .scaleAspectFill
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    override func streamViewContentOffsetDidChange(_ contentOffset: CGFloat) {
        let pos = max(0, contentOffset - minDist)
        let percentage = pos / maxDist
        imageView.alpha = 1 - percentage
    }
}
