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

    var imageView = UIImageView()
    var blurView : UIVisualEffectView = UIVisualEffectView()
    
    override func initialize() -> Void {
        super.initialize()
        
        let blurEffect = ThemeManager.sharedInstance.currentTheme.backgroundBlurEffect
        blurView.effect = blurEffect
        
        imageView.contentMode = .ScaleAspectFill
        self.addSubview(imageView)
        self.addSubview(blurView)
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
    override func applyThemeChangeAnimation() {
        super.applyThemeChangeAnimation()
        self.blurView.effect = ThemeManager.sharedInstance.currentTheme.backgroundBlurEffect
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