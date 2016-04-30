//
//  BlurredBackbroundView.swift
//  Accented
//
//  Created by Tiangong You on 4/29/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class BlurredBackbroundView: UIView {

    var imageView : UIImageView
    var blurView : UIVisualEffectView
    var vibrancyView : UIVisualEffectView
    var curtainView : UIView
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init(_ coder: NSCoder? = nil) {
        imageView = UIImageView()
        
        let blurEffect = UIBlurEffect(style: .Dark)
        blurView = UIVisualEffectView(effect: blurEffect)
        
        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        
        curtainView = UIView()
        
        if let coder = coder {
            super.init(coder: coder)!
        }
        else {
            super.init(frame: CGRectZero)
        }
        
        initialize()
    }
    
    var photo : PhotoModel?
    
    func initialize() -> Void {
        imageView.contentMode = .ScaleAspectFill
        self.addSubview(imageView)
        self.addSubview(blurView)
        self.addSubview(vibrancyView)
        
        curtainView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.8)
        self.addSubview(curtainView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
        blurView.frame = self.bounds
        vibrancyView.frame = self.bounds
        curtainView.frame = self.bounds
        
        if photo != nil {
            let url = NSURL(string: (photo?.imageUrls[ImageSize.Medium])!)
            imageView.af_setImageWithURL(url!)
        } else {
            imageView.image = nil
        }
    }

}
