//
//  DetailViewController.swift
//  Accented
//
//  Detail page view controller
//
//  Created by Tiangong You on 7/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailViewController: SectionViewController, DetailEntranceProxyAnimation, DetailLightBoxAnimation {

    // Photo model
    var photo : PhotoModel
    
    // Source image view from entrance transition
    var entranceAnimationImageView : UIImageView
    
    // Sections and UI elements
    private var photoSection : DetailPhotoSectionView!
    private var backgroundView : DetailBackgroundView!

    // All views that would participate entrance animation
    private var entranceAnimationViews = [DetailEntranceAnimation]()
    
    // Hero photo view
    var heroPhotoView : UIImageView {
        return photoSection.photoView
    }
    
    // Temporary proxy image view when pinching on the main photo view
    private var pinchProxyImageView : UIImageView?

    init(context : DetailNavigationContext) {
        self.entranceAnimationImageView = context.sourceImageView
        self.photo = context.initialSelectedPhoto
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Background view
        backgroundView = DetailBackgroundView(frame: self.view.bounds)
        self.view.insertSubview(backgroundView, at: 0)
    }

    private func initializeSections() {
        self.photoSection = DetailPhotoSectionView(photo)
        addSection(DetailHeaderSectionView(photo))
        addSection(photoSection)
        addSection(DetailDescriptionSectionView(photo))
        addSection(DetailMetadataSectionView(photo))
        addSection(DetailTagSectionView(photo))
        addSection(DetailCommentSectionView(photo))
        
        for section in sections {
            entranceAnimationViews.append(section as! DetailEntranceAnimation)
        }
        
        // Events
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnPhoto(_:)))
        photoSection.addGestureRecognizer(tap)
        
        let zoom = UIPinchGestureRecognizer(target: self, action: #selector(didPinchOnPhoto(_:)))
        photoSection.addGestureRecognizer(zoom)
        
        view.setNeedsLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard self.presentedViewController == nil else { return }
        
        // Transition to lightbox only if we're in landscape mode
        guard size.width > size.height else { return }
        
        // We cannot present the lightbox immediately since the transition will break
        // The workaround is to animate along with the coordinator and perform the modal presentation upon animation completion
        coordinator.animate(alongsideTransition: { (context) in
            self.view.alpha = 0
            }, completion: { (context) in
                self.presentLightBoxViewController(sourceImageView: self.heroPhotoView, useSourceImageViewAsProxy: false)
        })
    }
    
    // MARK: - Entrance animation
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func entranceAnimationWillBegin() {
        initializeSections()
        for view in entranceAnimationViews {
            view.entranceAnimationWillBegin()
        }
        
        backgroundView.alpha = 0
    }
    
    func performEntranceAnimation() {
        for view in entranceAnimationViews {
            view.performEntranceAnimation()
        }
        
        backgroundView.alpha = 1
    }
    
    func entranceAnimationDidFinish() {
        for view in entranceAnimationViews {
            view.entranceAnimationDidFinish()
        }
    }
    
    func desitinationRectForProxyView(_ photo: PhotoModel) -> CGRect {
        let maxWidth = view.bounds.size.width
        var f = DetailPhotoSectionView.targetRectForPhotoView(photo, width: maxWidth)
        f.origin.y = DetailHeaderSectionView.sectionHeight
        return f
    }

    // MARK: - Lightbox animation
    
    func lightBoxTransitionWillBegin() {
        photoSection.lightBoxTransitionWillBegin()
    }
    
    func lightboxTransitionDidFinish() {
        photoSection.lightboxTransitionDidFinish()
    }
    
    func performLightBoxTransition() {
        photoSection.performLightBoxTransition()
    }
    
    func desitinationRectForSelectedLightBoxPhoto(_ photo: PhotoModel) -> CGRect {
        return CGRect.zero
    }
    
    // MARK: - UIScrollViewDelegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Update background according to scroll position
        backgroundView.applyScrollingAnimation(scrollView.contentOffset)
    }
    
    // MARK: - Events
    
    @objc private func didTapOnPhoto(_ gesture : UITapGestureRecognizer) {
        presentLightBoxViewController(sourceImageView: heroPhotoView, useSourceImageViewAsProxy: false)
    }

    @objc private func didPinchOnPhoto(_ gesture : UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            didStartPinchOnPhoto()
        case .ended:
            didEndPinchOnPhoto()
        case .cancelled:
            didCancelPinchOnPhoto()
        case .failed:
            didCancelPinchOnPhoto()
        case .changed:
            photoDidReceivePinch(gesture)
        default: break
        }
    }

    private func didStartPinchOnPhoto() {
        // Create a proxy image view for the pinch action
        pinchProxyImageView = UIImageView(image: heroPhotoView.image)
        pinchProxyImageView!.contentMode = heroPhotoView.contentMode
        let proxyImagePosition = heroPhotoView.convert(heroPhotoView.bounds.origin, to: self.view)
        pinchProxyImageView!.frame = CGRect(x: proxyImagePosition.x, y: proxyImagePosition.y, width: heroPhotoView.bounds.width, height: heroPhotoView.bounds.height)
        self.view.addSubview(pinchProxyImageView!)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.contentView.alpha = 0
            self?.backgroundView.alpha = 0
            }, completion: nil)
    }
    
    private func didEndPinchOnPhoto() {
        // Use the temporary pinch proxy image view as the source view for lightbox transition
        self.presentLightBoxViewController(sourceImageView: pinchProxyImageView!, useSourceImageViewAsProxy: true)
        pinchProxyImageView?.removeFromSuperview()
    }
    
    private func photoDidReceivePinch(_ gesture: UIPinchGestureRecognizer) {
        pinchProxyImageView?.transform = CGAffineTransform(scaleX: gesture.scale, y: gesture.scale)
    }
    
    private func didCancelPinchOnPhoto() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.pinchProxyImageView?.transform = CGAffineTransform.identity
            self?.backgroundView.alpha = 1
            self?.contentView.alpha = 1
        }) { [weak self] (finished) in
            self?.heroPhotoView.isHidden = false
            self?.pinchProxyImageView?.removeFromSuperview()
            self?.pinchProxyImageView = nil
        }
    }
    
    // MARK: - Private
    
    private func presentLightBoxViewController(sourceImageView: UIImageView, useSourceImageViewAsProxy : Bool) {
        let lightboxViewController = DetailFullScreenImageViewController(photo: photo)
        let lightboxTransitioningDelegate = DetailLightBoxPresentationController(presentingViewController: self, presentedViewController: lightboxViewController, photo: photo, sourceImageView: sourceImageView, useSourceImageViewAsProxy: useSourceImageViewAsProxy)
        lightboxViewController.modalPresentationStyle = .custom
        lightboxViewController.transitioningDelegate = lightboxTransitioningDelegate
        
        self.present(lightboxViewController, animated: true, completion: nil)
    }
}
