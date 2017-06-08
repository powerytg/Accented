//
//  BlurredBackbroundView.swift
//  Accented
//
//  Created by Tiangong You on 4/29/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage
import Alamofire

class BlurredBackbroundView: ThemeableBackgroundView {

    private var imageView = UIImageView()
    private var blurView : UIVisualEffectView = UIVisualEffectView()
    
    override func initialize() -> Void {
        super.initialize()
        
        let blurEffect = ThemeManager.sharedInstance.currentTheme.backgroundBlurEffect
        blurView.effect = blurEffect
        
        imageView.contentMode = .scaleAspectFill
        self.addSubview(imageView)
        self.addSubview(blurView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard photo != nil else { return }
        
        imageView.frame = self.bounds
        blurView.frame = self.bounds
    }
    
    override func photoDidChange() {
        applyBackgroundImage(ThemeManager.sharedInstance.currentTheme.shouldUseDesaturatedBackground)
    }
    
    private func applyBackgroundImage(_ desaturated : Bool) {
        guard photo != nil else { return }
        let url = photo!.imageUrls[.Small]!
        guard url != nil else { return }
        
        // Initially hide the image view
        imageView.alpha = 0
        
        Alamofire.request(url!).responseData { [weak self] (response) in
            let image = UIImage(data : response.data!, scale : 1)
            self?.applyImageEffects(image!, desaturated: desaturated)
        }
    }
    
    private func applyImageEffects(_ image : UIImage, desaturated : Bool) {
        let input = PictureInput(image: image.cgImage!)
        let output = PictureOutput()
        let saturationFilter = SaturationAdjustment()
        saturationFilter.saturation = 0.25

        output.imageAvailableCallback = { outputImage in
            DispatchQueue.main.async(execute: { 
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
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
