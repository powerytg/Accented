//
//  JournalBackgroundView.swift
//  Accented
//
//  Created by Tiangong You on 5/19/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class JournalBackgroundView: ThemeableBackgroundView {
    
    var compressionRate : CGFloat = 0
    let compressionStartPosition : CGFloat = 100
    let compressionEndPosition : CGFloat = 400
    
    var imageView : UIImageView = UIImageView()
    var blurView : BlurView = DefaultNavBlurView()
    
    var journalTheme : JournalTheme {
        return ThemeManager.sharedInstance.currentTheme as! JournalTheme
    }
    
    override func initialize() -> Void {
        super.initialize()
        
        // Image view
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        
        if ThemeManager.sharedInstance.currentTheme is JournalTheme {
            imageView.image = journalTheme.backgroundLogoImage
        } else {
            imageView.image = nil;
        }
        
        // Blur view
        addSubview(blurView)
        blurView.alpha = 0
        
        // Perform the initial animation states
        imageView.alpha = 0
        imageView.transform = CGAffineTransform(translationX: 0, y: -30)
    }
    
    override func performEntranceAnimation(_ completed: @escaping () -> Void) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
            self?.imageView.alpha = 1
            self?.imageView.transform = CGAffineTransform.identity
            
        }) { (finished) in
            completed()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.frame = self.bounds
    }
    
    // MARK : - Events
    override func applyThemeChangeAnimation() {
        super.applyThemeChangeAnimation()
        self.blurView.blurEffect = ThemeManager.sharedInstance.currentTheme.backgroundBlurEffect
        
        if ThemeManager.sharedInstance.currentTheme is JournalTheme {
            imageView.image = journalTheme.backgroundLogoImage
        } else {
            imageView.image = nil;
        }
    }
    
    override func streamViewContentOffsetDidChange(_ contentOffset: CGFloat) {
        if contentOffset <= 0 || contentOffset <= compressionStartPosition {
            compressionRate = 0
        } else {
            compressionRate = 1 - (compressionEndPosition - contentOffset) / (compressionEndPosition - compressionStartPosition)
        }
        
        
        if compressionRate < 0 {
            compressionRate = 0
        }
        
        if compressionRate > 1 {
            compressionRate = 1
        }

        // Ease-in curve
        compressionRate = pow(compressionRate, 2)
        
        blurView.alpha = compressionRate
        blurView.setNeedsLayout()
        
        let scaleFactor = 1.0 + compressionRate
        imageView.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
    }
}
