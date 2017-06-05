//
//  PresetThumbnailView.swift
//  Accented
//
//  Preset thumbnail view
//
//  Created by Tiangong You on 6/4/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class PresetThumbnailView: UIView {

    var isSelected : Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    var preset : Preset
    var previewImage : UIImage? {
        didSet {
            imageView.image = previewImage
            setNeedsLayout()
        }
    }
    private var imageView = UIImageView()
    
    init(preset : Preset) {
        self.preset = preset
        super.init(frame: CGRect.zero)
        
        isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
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
