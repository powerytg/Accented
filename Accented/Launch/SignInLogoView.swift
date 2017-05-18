//
//  SignInLogoView.swift
//  Accented
//
//  Created by Tiangong You on 4/11/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class SignInLogoView: UIView {

    let layerCount = 11
    let upperFlipWings = [7, 8]
    let lowerFlipWings = [3, 6, 10, 11]
    let upperSlideWings = [1, 2, 9]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeLayers()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeLayers()
    }
    
    func initializeLayers() {
        for i in 1...self.layerCount {
            let layerImage = UIImage(named: "Logo.Layer\(i)")
            let layerView = UIImageView(image: layerImage)
            layerView.contentMode = UIViewContentMode.scaleAspectFit
            self.insertSubview(layerView, at: 0)
        }
        
        resetAnimations()
    }
    
    override func layoutSubviews() {
        for layerView in self.subviews as [UIView] {
            layerView.frame = self.bounds
        }
    }
    
    func resetAnimations() -> Void {
        for layerView in self.subviews as [UIView] {
            let layerIndex = self.subviews.index(of: layerView)
            layerView.layer.removeAllAnimations()
            
            layerView.layer.anchorPoint = CGPoint(x: 1.0, y: 0.55)
            layerView.layer.transform.m34 = 1 / 3500.0
            layerView.layer.zPosition = 100.0 * CGFloat(layerCount - layerIndex!)
        }
    }
    
    func performPerspectiveAnimation()  {
        // Cancel previous animations
        resetAnimations()
        
        let animationOptions : UIViewKeyframeAnimationOptions = [.repeat, .autoreverse]
        UIView.animateKeyframes(withDuration: 10, delay: 0.2, options: animationOptions, animations: {
            for layerView in self.subviews as [UIView] {
                let layerIndex = self.subviews.index(of: layerView)
                let imageIndex = self.layerCount - layerIndex!
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.8 * Double(arc4random()), animations: {
                    var angle:Double
                    if self.upperFlipWings.contains(imageIndex) {
                        angle = Double(imageIndex) * 1.6 * Double.pi / 180.0
                        layerView.layer.transform = CATransform3DRotate(layerView.layer.transform, -CGFloat(angle), 1, 0, 0)
                    } else if self.lowerFlipWings.contains(imageIndex) {
                        angle = Double(imageIndex) * 2.6 * Double.pi / 180.0
                        layerView.layer.transform = CATransform3DRotate(layerView.layer.transform, CGFloat(angle), 1, 0, 0)
                    } else if self.upperSlideWings.contains(imageIndex) {
                        angle = Double(imageIndex) * 2.2 * Double.pi / 180.0
                        layerView.layer.transform = CATransform3DRotate(layerView.layer.transform, -CGFloat(angle), 0, 0, 1)
                    } else {
                        angle = Double(imageIndex) * 1.8 * Double.pi / 180.0
                        layerView.layer.transform = CATransform3DRotate(layerView.layer.transform, CGFloat(angle), 1, 0, 1)
                    }
                    
                    layerView.alpha = CGFloat(10 + Double(arc4random_uniform(80)) / 100.0)
                })
            }
        }, completion: { (Bool) in
            // Ignore
        })
    
    }
}
