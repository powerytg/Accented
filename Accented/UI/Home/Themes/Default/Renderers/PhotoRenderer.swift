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
    
    private var photoModel : PhotoModel?
    var photo : PhotoModel? {
        get {
            return photoModel
        }
        
        set(value) {
            if value != photoModel {
                photoModel = value
                
                if photoModel != nil {
                    let url = NSURL(string: (photoModel?.imageUrls[ImageSize.Medium])!)
                    imageView.af_setImageWithURL(url!)
                } else {
                    imageView.image = nil
                }
            }
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
        NavigationService.sharedInstance.navigateToDetailPage(photo!, sourceView: imageView)
    }
}
