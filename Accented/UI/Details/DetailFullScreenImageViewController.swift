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

class DetailFullScreenImageViewController: UIViewController, DetailLightBoxAnimation {

    // Image view
    private var imageView  : InteractiveImageView?

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
        
        // Image view
        if let imageUrl = PhotoRenderer.preferredImageUrl(photo) {
            imageView = InteractiveImageView(imageUrl: imageUrl, frame: view.bounds)
            self.view.addSubview(imageView!)
        }
        
        // Back button
        self.view.addSubview(backButton)
        backButton.setImage(UIImage(named: "DetailBackButton"), for: UIControlState())
        backButton.addTarget(self, action: #selector(backButtonDidTap(_:)), for: .touchUpInside)
        backButton.sizeToFit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageView?.frame = self.view.bounds
        
        var f = backButton.frame
        f.origin.x = 10
        f.origin.y = 30
        backButton.frame = f
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] (context) in
            self?.imageView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            self?.imageView?.transitionToSize(size)
        }, completion: nil)
    }
    
    // MARK: - Events
    
    @objc private func backButtonDidTap(_ sender : UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
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
}
