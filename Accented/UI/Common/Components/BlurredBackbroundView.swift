//
//  BlurredBackbroundView.swift
//  Accented
//
//  Created by Tiangong You on 4/29/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import AlamofireImage

class BlurredBackbroundView: ThemeableBackgroundView {

    var imageView : UIImageView
    var blurView : UIVisualEffectView
    
    required init() {
        imageView = UIImageView()
        
        let blurEffect = ThemeManager.sharedInstance.currentTheme.backgroundBlurEffect
        blurView = UIVisualEffectView(effect: blurEffect)
        
        super.init()
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() -> Void {
        imageView.contentMode = .ScaleAspectFill
        self.addSubview(imageView)
        self.addSubview(blurView)
        
        // Events
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(appThemeDidChange(_:)), name: ThemeManagerEvents.appThemeDidChange, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func performEntranceAnimation(completed: (() -> Void)) {
        completed()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
        blurView.frame = self.bounds
        
        if photo != nil {
            let url = NSURL(string: (photo?.imageUrls[ImageSize.Medium])!)
            let filter = DesaturationFilter()
            
            if ThemeManager.sharedInstance.currentTheme.shouldUseDesaturatedBackground {
                imageView.af_setImageWithURL(
                    url!,
                    placeholderImage: nil,
                    filter: filter,
                    imageTransition: .CrossDissolve(0.2)
                )
            } else {
                imageView.af_setImageWithURL(
                    url!,
                    placeholderImage: nil,
                    imageTransition: .CrossDissolve(0.2)
                )
            }
        } 
    }

    // MARK : - Events
    func appThemeDidChange(notification : NSNotification) {
        UIView.animateWithDuration(0.3) { [weak self] in
            self?.blurView.effect = ThemeManager.sharedInstance.currentTheme.backgroundBlurEffect
        }
    }
}

// MARK: - Filters

// De-saturate filter lowers the saturation of an image
private struct DesaturationFilter: ImageFilter {
    var filter: Image -> Image {
        return { image in
            let parameters = [kCIInputSaturationKey : 0.25]
            return image.af_imageWithAppliedCoreImageFilter("CIColorControls", filterParameters: parameters) ?? image
        }
    }
}