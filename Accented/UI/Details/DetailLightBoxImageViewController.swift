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
    
    // Zooming state
    private var imageZoomed : Bool {
        return (scrollView.zoomScale != 1.0)
    }
    
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
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(didReceivePinch(_:)))
        self.view.addGestureRecognizer(pinch)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.frame = self.view.bounds
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        // Reset the scroll view content and scaling to default
        scrollView.frame = CGRectMake(0, 0, size.width, size.height)
        imageView.frame = CGRectMake(0, 0, size.width, size.height)
        scrollView.contentSize = size
        scrollView.contentOffset = CGPointZero
        scrollView.zoomScale = 1.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        resetScrollView()
    }
    
    override func cardSelectionDidChange(selected: Bool) {
        super.cardSelectionDidChange(selected)
        
        // Reset the scroll view content for non-selected cards
        if !selected {
            resetScrollView()
        }
    }
    
    // MARK: - Entrance animation
    
    func desitinationRectForProxyView(photo: PhotoModel) -> CGRect {
        return self.view.bounds
    }
    
    // MARK: - Events
    
    @objc private func didReceiveDoubleTap(gesture : UITapGestureRecognizer) {
        if imageZoomed {
            scrollView.setZoomScale(1.0, animated: true)
        } else {
            let center = gesture.locationInView(imageView)
            zoomToLocation(center, scale: scrollView.maximumZoomScale)
        }
    }

    @objc private func didReceivePinch(gesture : UIPinchGestureRecognizer) {
        switch gesture.state {
        case .Changed:
            pinchGestureDidChange(gesture)
        default:
            break
        }
    }

    // MARK: - UIScrollViewDelegate
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // MARK: - Gestures
    
    func shouldAllowExternalPanGesture() -> Bool {
        if !imageZoomed {
            return true
        }
        
//        if scrollView.contentOffset.x >= CGRectGetWidth(view.bounds) || scrollView.contentOffset.x <= 0 {
//            return true
//        }
        
        return false
    }
    
    // MARK: - Private

    private func initializeImageView() {
        let imageUrl = PhotoRenderer.preferredImageUrl(photo)
        guard imageUrl != nil else { return }
        imageView.af_setImageWithURL(imageUrl!)
        
        // Make the image view display the full image
        let w = CGRectGetWidth(self.view.bounds)
        let h = CGRectGetHeight(self.view.bounds)
        imageView.frame = CGRectMake(0, 0, w, h)
        scrollView.contentSize = imageView.frame.size
        
        // Calculate the min scale factor and max scale factor
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
    }

    private func zoomToLocation(location : CGPoint, scale : CGFloat) {
        let rectWidth = CGRectGetWidth(view.bounds) / scale
        let rectHeight = CGRectGetHeight(view.bounds) / scale
        let zoomRect = CGRectMake(location.x - rectWidth / 2, location.y - rectHeight / 2, rectWidth, rectHeight)
        scrollView.zoomToRect(zoomRect, animated: true)
        
        let w = CGRectGetWidth(self.view.bounds)
        let h = CGRectGetHeight(self.view.bounds)
        scrollView.contentOffset = CGPointMake(w / 2 - rectWidth / 2, h / 2 - rectHeight / 2)
    }
    
    private func resetScrollView() {
        scrollView.contentOffset = CGPointZero
        scrollView.zoomScale = 1.0
    }
    
    private func pinchGestureDidChange(gesture : UIPinchGestureRecognizer) {
        // Limit the scale range
        var scale : CGFloat = gesture.scale
        scale = max(scale, scrollView.minimumZoomScale)
        scale = min(scale, scrollView.maximumZoomScale)
        let center = gesture.locationInView(scrollView)
        zoomToLocation(center, scale: scale)
    }
}
