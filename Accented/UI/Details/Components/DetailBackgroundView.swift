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
    fileprivate var imageBaseWidth : CGFloat = 414
    
    fileprivate var topImageViewExpectedWidth : CGFloat = 324
    fileprivate var bottomImageViewExpectedWidth : CGFloat = 472
    fileprivate var topImage = UIImage(named: "DetailBackgroundTop")!
    fileprivate var bottomImage = UIImage(named: "DetailBackgroundBottom")!
    fileprivate var topImageView : UIImageView!
    fileprivate var bottomImageView : UIImageView!
    
    fileprivate var scaleFactor : CGFloat = 0
    fileprivate var topImageAspectRatio : CGFloat = 0
    fileprivate var bottomImageAspectRatio : CGFloat = 0
    fileprivate var topImageOriginalWidth : CGFloat = 0
    fileprivate var bottomImageOriginalWidth : CGFloat = 0
    
    // Minimal scroll distance required before the perspective effect would be applied
    fileprivate let minDist : CGFloat = 40
    
    // Maximum scroll distance required for perspective effect to be fully applied
    fileprivate let maxDist : CGFloat = 160
    
    // Curtain view
    fileprivate var curtainView = UIImageView(image: UIImage(named: "DetailBackgroundMask"))
    
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
        
        // Calculate scale factors for the images
        scaleFactor = UIScreen.main.bounds.width / imageBaseWidth
        topImageOriginalWidth = topImage.size.width
        topImageAspectRatio = topImage.size.height / topImage.size.width
        bottomImageOriginalWidth = bottomImage.size.width
        bottomImageAspectRatio = bottomImage.size.height / bottomImage.size.width
        
        topImageView = UIImageView(image: topImage)
        bottomImageView = UIImageView(image: bottomImage)
        
        addSubview(bottomImageView)
        bottomImageView.contentMode = .scaleAspectFit
        
        addSubview(topImageView)
        topImageView.contentMode = .scaleAspectFit
        
        // Curtain view
        addSubview(curtainView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var f = topImageView.frame
        f.size.width = topImageOriginalWidth * scaleFactor
        f.size.height = f.size.width * topImageAspectRatio
        f.origin.x = self.bounds.width - f.size.width + 20
        f.origin.y = -20
        topImageView.frame = f
        
        f = bottomImageView.frame
        f.size.width = bottomImageOriginalWidth * scaleFactor
        f.size.height = f.size.width * bottomImageAspectRatio
        f.origin.x = self.bounds.width - f.size.width + 30
        f.origin.y = -200
        bottomImageView.frame = f
        
        curtainView.frame = CGRect(x: 0, y: 80, width: self.bounds.width, height: self.bounds.height - 80)
    }
    
    // MARK: - DetailEntranceAnimation
    
    func entranceAnimationWillBegin() {
        topImageView.alpha = 0
        topImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8).concatenating(CGAffineTransform(translationX: 0, y: 40))
        
        bottomImageView.alpha = 0
        bottomImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8).concatenating(CGAffineTransform(translationX: 0, y: 40))
        
        curtainView.alpha = 0
    }
    
    func performEntranceAnimation() {
        UIView .addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.8, animations: { [weak self] in
            self?.topImageView.alpha = 1
            self?.topImageView.transform = CGAffineTransform.identity
        })
        
        UIView .addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1.0, animations: { [weak self] in
            self?.bottomImageView.alpha = 1
            self?.bottomImageView.transform = CGAffineTransform.identity
        })
    }
    
    func entranceAnimationDidFinish() {
        // Ignore
    }
    
    func applyScrollingAnimation(_ offset: CGPoint, contentSize: CGSize) {
        let pos = max(0, offset.y - minDist)
        let percentage = pos / maxDist
        
        topImageView.alpha = 1 - percentage
        bottomImageView.alpha = 1 - percentage / 2
    }
    
    func resetScrollingAnimation() {
        let animationOptions: UIViewAnimationOptions = UIViewAnimationOptions()
        let options: UIViewKeyframeAnimationOptions = UIViewKeyframeAnimationOptions(rawValue: animationOptions.rawValue)
        UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: options, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: { [weak self] in
                self?.curtainView.alpha = 1
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 1, animations: { [weak self] in
                self?.bottomImageView.alpha = 1
            })

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: { [weak self] in
                self?.topImageView.alpha = 1
                })

            }, completion: nil)
    }
}
