//
//  PhotoRenderer.swift
//  Accented
//
//  Created by Tiangong You on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import AlamofireImage

protocol PhotoRendererDelegate : NSObjectProtocol {
    func photoRendererDidReceiveTap(renderer : PhotoRenderer)
}

class PhotoRenderer: UIView {

    var imageView : UIImageView
    weak var delegate : PhotoRendererDelegate?
    
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
    
    private var photoModel : PhotoModel?
    var photo : PhotoModel? {
        get {
            return photoModel
        }
        
        set(value) {
            if value != photoModel {
                photoModel = value
                
                if photoModel != nil {
                    let url = PhotoRenderer.preferredImageUrl(photoModel)
                    if url != nil {
                        imageView.af_setImageWithURL(url!)
                    } else {
                        imageView.image = nil
                    }
                } else {
                    imageView.image = nil
                }
            }
        }
    }
    
    // MARK: - Private
    
    static func preferredImageUrl(photo : PhotoModel?) -> NSURL? {
        guard photo != nil else { return nil }
        
        if let url = photo!.imageUrls[.Large] {
            return NSURL(string: url)
        } else if let url = photo!.imageUrls[.Medium] {
            return NSURL(string: url)
        } else if let url = photo!.imageUrls[.Small] {
            return NSURL(string: url)
        } else {
            return nil
        }
    }

    func initialize() -> Void {
        imageView.contentMode = .ScaleAspectFill
        self.addSubview(imageView)
        
        // Gestures
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didReceiveTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
    }
    
    @objc private func didReceiveTap(tap :UITapGestureRecognizer) {
        delegate?.photoRendererDidReceiveTap(self)
    }
}
