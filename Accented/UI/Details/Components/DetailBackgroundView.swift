//
//  DetailBackgroundView.swift
//  Accented
//
//  Created by Tiangong You on 8/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailBackgroundView: UIView, DetailEntranceAnimation {

    // Image widths are based on iPhone 6+ screen width (414 pt)
    private var imageBaseWidth : CGFloat = 414
    
    private var topImageViewExpectedWidth : CGFloat = 324
    private var bottomImageViewExpectedWidth : CGFloat = 472
    private var topImage = UIImage(named: "DetailBackgroundTop")!
    private var bottomImage = UIImage(named: "DetailBackgroundBottom")!
    private var topImageView : UIImageView!
    private var bottomImageView : UIImageView!
    
    private var scaleFactor : CGFloat = 0
    private var topImageAspectRatio : CGFloat = 0
    private var bottomImageAspectRatio : CGFloat = 0
    private var topImageOriginalWidth : CGFloat = 0
    private var bottomImageOriginalWidth : CGFloat = 0
    
    // Minimal scroll distance required before the perspective effect would be applied
    private let minDist : CGFloat = 40
    
    // Maximum scroll distance required for perspective effect to be fully applied
    private let maxDist : CGFloat = 160
    
    // Curtain view
    private var curtainView = UIImageView(image: UIImage(named: "DetailBackgroundMask"))
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    private func initialize() {
        self.clipsToBounds = true
        
        // Calculate scale factors for the images
        scaleFactor = CGRectGetWidth(UIScreen.mainScreen().bounds) / imageBaseWidth
        topImageOriginalWidth = topImage.size.width
        topImageAspectRatio = topImage.size.height / topImage.size.width
        bottomImageOriginalWidth = bottomImage.size.width
        bottomImageAspectRatio = bottomImage.size.height / bottomImage.size.width
        
        topImageView = UIImageView(image: topImage)
        bottomImageView = UIImageView(image: bottomImage)
        
        addSubview(bottomImageView)
        bottomImageView.contentMode = .ScaleAspectFit
        
        addSubview(topImageView)
        topImageView.contentMode = .ScaleAspectFit
        
        // Curtain view
        addSubview(curtainView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var f = topImageView.frame
        f.size.width = topImageOriginalWidth * scaleFactor
        f.size.height = f.size.width * topImageAspectRatio
        f.origin.x = CGRectGetWidth(self.bounds) - f.size.width + 20
        f.origin.y = -20
        topImageView.frame = f
        
        f = bottomImageView.frame
        f.size.width = bottomImageOriginalWidth * scaleFactor
        f.size.height = f.size.width * bottomImageAspectRatio
        f.origin.x = CGRectGetWidth(self.bounds) - f.size.width + 30
        f.origin.y = -200
        bottomImageView.frame = f
        
        curtainView.frame = CGRectMake(0, 80, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 80)
    }
    
    // MARK: - DetailEntranceAnimation
    
    func entranceAnimationWillBegin() {
        topImageView.alpha = 0
        topImageView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.8, 0.8), CGAffineTransformMakeTranslation(0, 40))
        
        bottomImageView.alpha = 0
        bottomImageView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.8, 0.8), CGAffineTransformMakeTranslation(0, 40))
    }
    
    func performEntranceAnimation() {
        UIView .addKeyframeWithRelativeStartTime(0, relativeDuration: 0.8, animations: { [weak self] in
            self?.topImageView.alpha = 1
            self?.topImageView.transform = CGAffineTransformIdentity
        })
        
        UIView .addKeyframeWithRelativeStartTime(0.5, relativeDuration: 1.0, animations: { [weak self] in
            self?.bottomImageView.alpha = 1
            self?.bottomImageView.transform = CGAffineTransformIdentity
        })
    }
    
    func entranceAnimationDidFinish() {
        // Ignore
    }
    
    func applyScrollingAnimation(offset: CGPoint, contentSize: CGSize) {
        let pos = max(0, offset.y - minDist)
        let percentage = pos / maxDist
        
        topImageView.alpha = 1 - percentage
        bottomImageView.alpha = 1 - percentage / 2
    }
    
    func resetScrollingAnimation() {
        let animationOptions: UIViewAnimationOptions = .CurveEaseInOut
        let options: UIViewKeyframeAnimationOptions = UIViewKeyframeAnimationOptions(rawValue: animationOptions.rawValue)
        UIView.animateKeyframesWithDuration(0.8, delay: 0, options: options, animations: {
            
            UIView.addKeyframeWithRelativeStartTime(0.4, relativeDuration: 1, animations: { [weak self] in
                self?.bottomImageView.alpha = 1
            })

            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.5, animations: { [weak self] in
                self?.topImageView.alpha = 1
                })

            }, completion: nil)
    }
}
