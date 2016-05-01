//
//  BlurredBackbroundView.swift
//  Accented
//
//  Created by Tiangong You on 4/29/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import AlamofireImage

class BlurredBackbroundView: UIView {

    var imageView : UIImageView
    var blurView : UIVisualEffectView
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init(_ coder: NSCoder? = nil) {
        imageView = UIImageView()
        
        let blurEffect = UIBlurEffect(style: .Dark)
        blurView = UIVisualEffectView(effect: blurEffect)
        
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
        blurView.frame = self.bounds
        
        if photo != nil {
            let url = NSURL(string: (photo?.imageUrls[ImageSize.Medium])!)
            let filter = DesaturationFilter()
            imageView.af_setImageWithURL(
                url!,
                placeholderImage: nil,
                filter: filter,
                imageTransition: .CrossDissolve(0.2)
            )
        } else {
            imageView.image = nil
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