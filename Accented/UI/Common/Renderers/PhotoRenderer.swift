//
//  PhotoRenderer.swift
//  Accented
//
//  Created by Tiangong You on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotoRenderer: UIView {

    var imageView : UIImageView
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init(_ coder: NSCoder? = nil) {
        imageView = UIImageView()
        
        if let coder = coder {
            super.init(coder: coder)!
        }
        else {
            super.init(frame: CGRectZero)
        }
        
        initialize()
    }
    
    var photoModel : PhotoModel?
    var photo : PhotoModel? {
        set(value) {
            if photoModel != value {
                photoModel = value
            }
            
            if photoModel != nil {
                let url = NSURL(string: (value?.imageUrls[ImageSize.Large])!)
                imageView.af_setImageWithURL(url!)
            } else {
                imageView.image = nil
            }
        }
        
        get {
            return photoModel
        }
    }
    
    func initialize() -> Void {
        self.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        self.addSubview(imageView)
        
        let views = ["imageView" : imageView]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[imageView]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activateConstraints(constraints)
    }

}
