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
        self.init(frame : CGRect.zero)
    }

    func initialize() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.image = darkIndicatorImage
        self.addSubview(loadingIndicator)
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: loadingIndicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        constraints.append(NSLayoutConstraint(item: loadingIndicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        NSLayoutConstraint.activate(constraints)
        
        // Auto start animation
        startLoadingAnimation()
    }
    
    func startLoadingAnimation() {
        loadingIndicator.layer.removeAllAnimations()
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = Double.pi * 2
        rotationAnimation.duration = 1.0
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = Float.infinity
        loadingIndicator.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func stopLoadingAnimation() {
        loadingIndicator.layer.removeAllAnimations()
    }    
}
