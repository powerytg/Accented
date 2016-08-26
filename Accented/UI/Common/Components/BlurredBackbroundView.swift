//
//  BlurredBackbroundView.swift
//  Accented
//
//  Created by Tiangong You on 4/29/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import SDWebImage
import GPUImage

class BlurredBackbroundView: ThemeableBackgroundView {

    private var imageView = UIImageView()
    private var blurView : UIVisualEffectView = UIVisualEffectView()
    
    private var saturationFilter = SaturationAdjustment()
    private let output = PictureOutput()
    
    override func initialize() -> Void {
        super.initialize()
        
        // Setup filters
        saturationFilter.saturation = 0.25
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
        guard photo != nil else { return }
        
        imageView.frame = self.bounds
        blurView.frame = self.bounds
        
        applyBackgroundImage(ThemeManager.sharedInstance.currentTheme.shouldUseDesaturatedBackground)
    }

    private func applyBackgroundImage(desaturated : Bool) {
        guard photo != nil else { return }
        let url = PhotoRenderer.preferredImageUrl(photo!)
        guard url != nil else { return }
        
        // Initially hide the image view
        imageView.alpha = 0
        
        let downloader = SDWebImageDownloader.sharedDownloader()
        downloader.downloadImageWithURL(url!, options: [], progress: nil) { [weak self] (image, data, error, finished) in
            guard image != nil && finished == true else { return }
            self?.applyImageEffects(image, desaturated: desaturated)
        }
    }
    
    private func applyImageEffects(image : UIImage, desaturated : Bool) {
        let input = PictureInput(image: image.CGImage!)
        
        output.imageAvailableCallback = { outputImage in
            dispatch_async(dispatch_get_main_queue(), { 
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { [weak self] in
                    self?.imageView.image = outputImage
                    self?.imageView.alpha = 1
                    }, completion: nil)
            })
        }

        input --> saturationFilter --> output
        input.processImage(synchronously: true)
    }
    
    // MARK : - Events
    override func applyThemeChangeAnimation() {
        super.applyThemeChangeAnimation()
        self.blurView.effect = ThemeManager.sharedInstance.currentTheme.backgroundBlurEffect
    }
}
