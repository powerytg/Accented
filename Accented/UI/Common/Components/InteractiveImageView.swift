//
//  InteractiveImageView.swift
//  Accented
//
//  interactiveImageView allows user to zoom, pinch, pan on an image
//  The image can either be a local image, or represented by a remote url
//
//  Created by You, Tiangong on 6/8/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class InteractiveImageView: UIView, UIScrollViewDelegate {
    
    // Image view
    private var imageView  = UIImageView()
    
    // Scroll view
    private var scrollView = UIScrollView()
    
    // Zooming state
    private var imageZoomed : Bool {
        return (scrollView.zoomScale != 1.0)
    }
    
    // Optional image url
    private var imageUrl : URL?
    
    // Optional image
    private var image : UIImage?
    
    // Optional image url string
    private var imageUrlString : String?
    
    init(imageUrl : URL, frame : CGRect) {
        self.imageUrl = imageUrl
        super.init(frame: frame)
        initialize()
    }
    
    init(imageUrlString : String, frame : CGRect) {
        self.imageUrlString = imageUrlString
        super.init(frame: frame)
        initialize()
    }
    
    init(image : UIImage, frame : CGRect) {
        self.image = image
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        self.addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        
        scrollView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        initializeImageView()
        
        // Events
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didReceiveDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(didReceivePinch(_:)))
        self.addGestureRecognizer(pinch)
    }
    
    func transitionToSize(_ size : CGSize) {
        scrollView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        scrollView.contentSize = size
        scrollView.contentOffset = CGPoint.zero
        scrollView.zoomScale = 1.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        scrollView.contentSize = bounds.size
    }
    
    // MARK: - Events
    
    @objc private func didReceiveDoubleTap(_ gesture : UITapGestureRecognizer) {
        if imageZoomed {
            scrollView.setZoomScale(1.0, animated: true)
        } else {
            let center = gesture.location(in: imageView)
            zoomToLocation(center, scale: scrollView.maximumZoomScale)
        }
    }
    
    @objc private func didReceivePinch(_ gesture : UIPinchGestureRecognizer) {
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
    
    // MARK: - Private
    
    private func initializeImageView() {
        if image != nil {
            imageView.image = image
        } else if imageUrl != nil {
            imageView.sd_setImage(with: imageUrl)
        } else if imageUrlString != nil {
            if let url = URL(string : imageUrlString!) {
                imageView.sd_setImage(with: url)
            } else {
                debugPrint("Cannot load image from \(imageUrlString)")
            }
        } else {
            debugPrint("Both image and imageUrl is nil. Image is not loaded")
        }
        
        // Make the image view display the full image
        let w = bounds.width
        let h = bounds.height
        imageView.frame = CGRect(x: 0, y: 0, width: w, height: h)
        scrollView.contentSize = imageView.frame.size
        
        // Calculate the min scale factor and max scale factor
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
    }
    
    private func zoomToLocation(_ location : CGPoint, scale : CGFloat) {
        let rectWidth = bounds.width / scale
        let rectHeight = bounds.height / scale
        let zoomRect = CGRect(x: location.x - rectWidth / 2, y: location.y - rectHeight / 2, width: rectWidth, height: rectHeight)
        scrollView.zoom(to: zoomRect, animated: true)
    }
    
    private func pinchGestureDidChange(_ gesture : UIPinchGestureRecognizer) {
        // Limit the scale range
        var scale : CGFloat = gesture.scale
        scale = max(scale, scrollView.minimumZoomScale)
        scale = min(scale, scrollView.maximumZoomScale)
        let center = gesture.location(in: scrollView)
        zoomToLocation(center, scale: scale)
    }
}
