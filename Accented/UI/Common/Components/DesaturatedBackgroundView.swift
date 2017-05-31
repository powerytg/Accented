//
//  DesaturatedBackgroundView.swift
//  Accented
//
//  A DesaturatedBackgroundView provides a desaturated look and feel to an image. 
//  This view is suitable as a background view for almost all types of images
//  In addition, the image downloaded from remote will be optimized for mobile usage
//
//  Created by You, Tiangong on 5/31/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import SDWebImage
import GPUImage

protocol DesaturatedBackgroundViewDelegate {
    func backgroundViewDidFinishedTransition()
}

class DesaturatedBackgroundView: UIImageView {
    var delegate : DesaturatedBackgroundViewDelegate?
    
    var url : String? {
        didSet {
            if url != nil {
                downloadImage()
            }
        }
    }
    
    fileprivate func downloadImage() {
        guard let urlString = self.url else { return }
        let uri = URL(string: urlString)
        guard uri != nil else { return }
        
        let downloader = SDWebImageDownloader.shared()
        _ = downloader?.downloadImage(with: uri!, options: [], progress: nil) { [weak self] (source, data, error, finished) in
            guard source != nil && finished == true else { return }
            
            // If the image is too large, downscale it
            if let scaledImage = self?.downscaleImageIfNecessary(source!) {
                self?.performImageTransition(scaledImage)
            }
        }
    }
    
    // See this article: http://nshipster.com/image-resizing/
    fileprivate func downscaleImageIfNecessary(_ source : UIImage) -> CGImage {
        // Calculate a scale
        let w = UIScreen.main.bounds.width * UIScreen.main.scale
        let h = UIScreen.main.bounds.height * UIScreen.main.scale
        if source.size.width <= w && source.size.height <= h {
            return source.cgImage!
        }
        
        let scale = min(w / source.size.width, h / source.size.height)
        let size = source.size.applying(CGAffineTransform(scaleX: scale, y: scale))
        UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
        source.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!.cgImage!
    }

    fileprivate func performImageTransition(_ source : CGImage) {
        let input = PictureInput(image: source)
        let output = PictureOutput()
        
        output.imageAvailableCallback = { outputImage in
            DispatchQueue.main.async { [weak self] in
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                        self?.alpha = 0
                    }, completion: { [weak self](finished) in
                        self?.fadeInCoverImage(outputImage)
                    })
            }
        }
        
        let saturationFilter = SaturationAdjustment()
        saturationFilter.saturation = 0.25
        
        input --> saturationFilter --> output
        input.processImage(synchronously: true)
    }
    
    fileprivate func fadeInCoverImage(_ source : UIImage) {
        self.image = source
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                self?.alpha = 0.4
            }, completion: { [weak self] (finished) in
                self?.delegate?.backgroundViewDidFinishedTransition()
            })
    }
}
