//
//  ColorPresetThumbnailView.swift
//  Accented
//
//  Created by You, Tiangong on 6/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

class ColorPresetThumbnailView : UIView {
    
    var isSelected : Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    var colorPresetImageName : String?
    var imageView = UIImageView()
    var previewImage : UIImage? {
        didSet {
            imageView.image = previewImage
            setNeedsLayout()
        }
    }
    
    init(colorPresetImageName : String?, frame : CGRect) {
        self.colorPresetImageName = colorPresetImageName
        super.init(frame: frame)
        
        isUserInteractionEnabled = true
        
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        
        self.layer.borderColor = UIColor.yellow.cgColor
        self.layer.cornerRadius = 12.0
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = self.bounds
        
        if isSelected {
            layer.borderWidth = 4
        } else {
            layer.borderWidth = 0
        }
    }
}
