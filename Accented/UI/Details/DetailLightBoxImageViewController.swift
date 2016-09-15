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
    fileprivate var imageView  = UIImageView()
    
    // Scroll view
    fileprivate var scrollView = UIScrollView()
    
    // Zooming state
    fileprivate var imageZoomed : Bool {
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
        imageView.contentMode = .scaleAspectFit
        
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

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Reset the scroll view content and scaling to default
        scrollView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        scrollView.contentSize = size
        scrollView.contentOffset = CGPoint.zero
        scrollView.zoomScale = 1.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        resetScrollView()
    }
    
    override func cardSelectionDidChange(_ selected: Bool) {
        super.cardSelectionDidChange(selected)
        
        // Reset the scroll view content for non-selected cards
        if !selected {
            resetScrollView()
        }
    }
    
    // MARK: - Entrance animation
    
    func desitinationRectForProxyView(_ photo: PhotoModel) -> CGRect {
        return self.view.bounds
    }
    
    // MARK: - Events
    
    @objc fileprivate func didReceiveDoubleTap(_ gesture : UITapGestureRecognizer) {
        if imageZoomed {
            scrollView.setZoomScale(1.0, animated: true)
        } else {
            let center = gesture.location(in: imageView)
            zoomToLocation(center, scale: scrollView.maximumZoomScale)
        }
    }

    @objc fileprivate func didReceivePinch(_ gesture : UIPinchGestureRecognizer) {
        switch gesture.state {
        case .changed:
            pinchGestureDidChange(gesture)
        default:
            break
        }
    }

    // MARK: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
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

    fileprivate func initializeImageView() {
        let imageUrl = PhotoRenderer.preferredImageUrl(photo)
        guard imageUrl != nil else { return }
        imageView.sd_setImage(with: imageUrl!)
        
        // Make the image view display the full image
        let w = self.view.bounds.width
        let h = self.view.bounds.height
        imageView.frame = CGRect(x: 0, y: 0, width: w, height: h)
        scrollView.contentSize = imageView.frame.size
        
        // Calculate the min scale factor and max scale factor
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
    }

    fileprivate func zoomToLocation(_ location : CGPoint, scale : CGFloat) {
        let rectWidth = view.bounds.width / scale
        let rectHeight = view.bounds.height / scale
        let zoomRect = CGRect(x: location.x - rectWidth / 2, y: location.y - rectHeight / 2, width: rectWidth, height: rectHeight)
        scrollView.zoom(to: zoomRect, animated: true)
    }
    
    fileprivate func resetScrollView() {
        scrollView.contentOffset = CGPoint.zero
        scrollView.zoomScale = 1.0
    }
    
    fileprivate func pinchGestureDidChange(_ gesture : UIPinchGestureRecognizer) {
        // Limit the scale range
        var scale : CGFloat = gesture.scale
        scale = max(scale, scrollView.minimumZoomScale)
        scale = min(scale, scrollView.maximumZoomScale)
        let center = gesture.location(in: scrollView)
        zoomToLocation(center, scale: scale)
    }
}
