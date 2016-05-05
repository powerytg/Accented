//
//  InlineLoadingView.swift
//  Accented
//
//  Created by You, Tiangong on 5/4/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class InlineLoadingView: UIView {

    let darkIndicatorImage = UIImage(named: "DarkLoadingIndicator")
    var loadingIndicator = UIImageView(image: UIImage(named: "DarkLoadingIndicator"))
    
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
    }

    func initialize() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.image = darkIndicatorImage
        self.addSubview(loadingIndicator)
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: loadingIndicator, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0))
        constraints.append(NSLayoutConstraint(item: loadingIndicator, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0))
        NSLayoutConstraint.activateConstraints(constraints)
        
        // Auto start animation
        startLoadingAnimation()
    }
    
    func startLoadingAnimation() {
        loadingIndicator.layer.removeAllAnimations()
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = M_PI * 2
        rotationAnimation.duration = 1.0
        rotationAnimation.cumulative = true
        rotationAnimation.repeatCount = Float.infinity
        loadingIndicator.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func stopLoadingAnimation() {
        loadingIndicator.layer.removeAllAnimations()
    }    
}
