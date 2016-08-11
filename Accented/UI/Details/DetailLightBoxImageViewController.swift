//
//  DetailLightBoxImageViewController.swift
//  Accented
//
//  Created by Tiangong You on 8/8/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailLightBoxImageViewController: CardViewController {

    // Image view
    private var imageView  = UIImageView()
    
    // Photo model
    var photo : PhotoModel? {
        didSet {
            if photo == nil {
                imageView.image = nil
            } else {
                imageView.af_setImageWithURL(NSURL(string: photo!.imageUrls[.Medium]!)!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(imageView)
        imageView.contentMode = .ScaleAspectFit
        
        
        // Events
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didReceiveDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageView.frame = self.view.bounds
    }

    override func cardSelectionDidChange(selected: Bool) {
        super.cardSelectionDidChange(selected)
    }

    // MARK: - Entrance animation
    
    func desitinationRectForProxyView(photo: PhotoModel) -> CGRect {
        return self.view.bounds
    }
    
    // MARK: - Events
    @objc private func didReceiveDoubleTap(gesture : UITapGestureRecognizer) {
        let scaleFactor : CGFloat = 2
        var targetFrame = imageView.frame
        let widthDiff = CGRectGetWidth(imageView.frame) * (scaleFactor - 1)
        let heightDiff = CGRectGetHeight(imageView.frame) * (scaleFactor - 1)
        targetFrame.size.width += widthDiff
        targetFrame.size.height += heightDiff
        targetFrame.origin.x -= widthDiff
        targetFrame.origin.y -= heightDiff
        
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseIn, animations: { [weak self] in
            self?.imageView.frame = targetFrame
            }, completion: nil)
    }
    
}
