//
//  DetailLightBoxImageViewController.swift
//  Accented
//
//  Created by Tiangong You on 8/8/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailLightBoxImageViewController: CardViewController, UIScrollViewDelegate {

    // Image view
    private var imageView  = UIImageView()
    
    // Scroll view
    private var scrollView = UIScrollView()
    
    // Normal scale factor
    private var normalScaleFactor : CGFloat?
    
    // Max scale factor
    private var maxScaleFactor : CGFloat?
    
    // Photo model
    var photo : PhotoModel? {
        didSet {
            if photo == nil {
                imageView.image = nil
            } else {
                initializeImageView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        
        scrollView.addSubview(imageView)
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
        scrollView.frame = self.view.bounds
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
        let center = gesture.locationInView(self.scrollView)
        let zoomRect = CGRectMake(center.x, center.y, photo!.width / 2, photo!.height / 2)
        scrollView.zoomToRect(zoomRect, animated: true)
    }

    // MARK: - UIScrollViewDelegate
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // MARK: - Gestures
    
    func shouldAllowExternalPanGesture() -> Bool {
        if scrollView.zoomScale == normalScaleFactor! {
            return true
        }
        
        if scrollView.contentOffset.x >= (photo!.width * scrollView.zoomScale / UIScreen.mainScreen().scale) {
            return true
        }
        
        return false
    }
    
    // MARK: - Private

    private func initializeImageView() {
        let imageUrl = PhotoRenderer.preferredImageUrl(photo)
        guard imageUrl != nil else { return }
        imageView.af_setImageWithURL(imageUrl!)
        
        // Make the image view display the full image
        imageView.frame = CGRectMake(0, 0, photo!.width, photo!.height)
        scrollView.contentSize = CGSizeMake(photo!.width, photo!.height)
        
        // Calculate the min scale factor and max scale factor
        let widthFactor = CGRectGetWidth(self.view.bounds) / photo!.width
        let heightFactor = CGRectGetHeight(self.view.bounds) / photo!.height
        normalScaleFactor = min(widthFactor, heightFactor)
        scrollView.minimumZoomScale = normalScaleFactor! / 2
        scrollView.maximumZoomScale = normalScaleFactor! * 2
        scrollView.setZoomScale(normalScaleFactor!, animated: false)
    }

}
