//
//  DetailFullScreenImageViewController.swift
//  Accented
//
//  Detail page full screen image view controller
//  This page allows zooming and pinching on the image
//
//  Created by You, Tiangong on 6/1/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class DetailFullScreenImageViewController: UIViewController, UIScrollViewDelegate, DetailLightBoxAnimation {

    // Image view
    private var imageView  = UIImageView()
    
    // Scroll view
    private var scrollView = UIScrollView()
    
    // Zooming state
    private var imageZoomed : Bool {
        return (scrollView.zoomScale != 1.0)
    }
    
    // Photo model
    var photo : PhotoModel
    
    // Back button
    private var backButton = UIButton(type: .custom)
    
    init(photo : PhotoModel) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        initializeImageView()
        
        // Back button
        self.view.addSubview(backButton)
        backButton.setImage(UIImage(named: "DetailBackButton"), for: UIControlState())
        backButton.addTarget(self, action: #selector(backButtonDidTap(_:)), for: .touchUpInside)
        backButton.sizeToFit()

        // Events
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didReceiveDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(didReceivePinch(_:)))
        self.view.addGestureRecognizer(pinch)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.frame = self.view.bounds
        
        var f = backButton.frame
        f.origin.x = 10
        f.origin.y = 30
        backButton.frame = f
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
    
    // MARK: - Events
    
    @objc private func backButtonDidTap(_ sender : UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

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
    
    // MARK: - Lightbox animation
    
    func lightBoxTransitionWillBegin() {
        // Initially hide all the conent
        view.isHidden = true
    }
    
    func lightboxTransitionDidFinish() {
        view.isHidden = false
        self.view.backgroundColor = UIColor.black
    }
    
    func performLightBoxTransition() {
        // Do nothing
    }
    
    func desitinationRectForSelectedLightBoxPhoto(_ photo: PhotoModel) -> CGRect {
        return self.view.bounds
    }
    
    // MARK: - Private
    
    private func initializeImageView() {
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
    
    private func zoomToLocation(_ location : CGPoint, scale : CGFloat) {
        let rectWidth = view.bounds.width / scale
        let rectHeight = view.bounds.height / scale
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
