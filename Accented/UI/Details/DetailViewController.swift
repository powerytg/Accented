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

class DetailViewController: UIViewController, DetailEntranceProxyAnimation, DetailLightBoxAnimation, SectionViewDelegate, UIScrollViewDelegate {

    // Photo model
    var photo : PhotoModel
    
    // Source image view from entrance transition
    var entranceAnimationImageView : UIImageView
    
    fileprivate let contentBottomPadding : CGFloat = 25
    fileprivate let sectionGap : CGFloat = 15
    
    // Sections
    fileprivate var sections = [DetailSectionViewBase]()
    fileprivate var photoSection : DetailPhotoSectionView!
    fileprivate var backgroundView : DetailBackgroundView!
    fileprivate var scrollView = UIScrollView()
    fileprivate var contentView = UIView()
    fileprivate var backButton = UIButton(type: .custom)

    // Hero photo view
    var heroPhotoView : UIImageView {
        return photoSection.photoView
    }
    
    // Temporary proxy image view when pinching on the main photo view
    fileprivate var pinchProxyImageView : UIImageView?

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
        self.view.clipsToBounds = false
        self.view.backgroundColor = UIColor.clear
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Background view
        backgroundView = DetailBackgroundView(frame: self.view.bounds)
        self.view.insertSubview(backgroundView, at: 0)
        
        // Setup scroll view and content view
        scrollView.clipsToBounds = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.addSubview(contentView)
        self.view.addSubview(scrollView)

        // Back button
        self.view.addSubview(backButton)
        backButton.setImage(UIImage(named: "DetailBackButton"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonDidTap(_:)), for: .touchUpInside)
        backButton.sizeToFit()
    }

    fileprivate func initializeSections() {
        sections.append(DetailHeaderSectionView(photo))
        
        self.photoSection = DetailPhotoSectionView(photo)
        sections.append(photoSection)

        sections.append(DetailDescriptionSectionView(photo))
        sections.append(DetailMetadataSectionView(photo))
        sections.append(DetailTagSectionView(photo))
        sections.append(DetailCommentSectionView(photo))
        
        for section in sections {
            section.delegate = self
            contentView.addSubview(section)
        }
        
        // Events
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnPhoto(_:)))
        photoSection.addGestureRecognizer(tap)
        
        let zoom = UIPinchGestureRecognizer(target: self, action: #selector(didPinchOnPhoto(_:)))
        photoSection.addGestureRecognizer(zoom)
        
        view.setNeedsLayout()
    }
    
    // MARK: - Layout
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        // Background view
        backgroundView.frame = self.view.bounds
        
        // Back button
        var f = backButton.frame
        f.origin.x = 10
        f.origin.y = 30
        backButton.frame = f
        
        // Content view
        var nextY : CGFloat = 0
        for section in sections {
            var f = section.frame
            f.origin.y = nextY
            f.size.width = view.bounds.size.width
            f.size.height = section.height
            section.frame = f
            section.setNeedsLayout()
            
            nextY += section.height
            
            section.isHidden = !(section.height > 0)
            if section.height != 0 {
                nextY += sectionGap
            }
        }
        
        // Update scroll view content size
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.bounds.size.width, height: nextY + contentBottomPadding)
        contentView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
    }
    
    // MARK: - Entrance animation
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func entranceAnimationWillBegin() {
    }
    
    func performEntranceAnimation() {
    }
    
    func entranceAnimationDidFinish() {
        initializeSections()
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Update background according to scroll position
        backgroundView.applyScrollingAnimation(scrollView.contentOffset, contentSize: scrollView.contentSize)
    }
    
    // MARK: - SectionViewDelegate
    
    func sectionViewWillChangeSize(_ section: SectionViewBase) {
        view.setNeedsLayout()
    }
    
    // MARK: - Events
    
    @objc fileprivate func backButtonDidTap(_ sender : UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func didTapOnPhoto(_ gesture : UITapGestureRecognizer) {
        presentLightBoxViewController(sourceImageView: heroPhotoView, useSourceImageViewAsProxy: false)
    }

    @objc fileprivate func didPinchOnPhoto(_ gesture : UIPinchGestureRecognizer) {
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

    fileprivate func didStartPinchOnPhoto() {
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
    
    fileprivate func didEndPinchOnPhoto() {
        // Use the temporary pinch proxy image view as the source view for lightbox transition
        self.presentLightBoxViewController(sourceImageView: pinchProxyImageView!, useSourceImageViewAsProxy: true)
        pinchProxyImageView?.removeFromSuperview()
    }
    
    fileprivate func photoDidReceivePinch(_ gesture: UIPinchGestureRecognizer) {
        pinchProxyImageView?.transform = CGAffineTransform(scaleX: gesture.scale, y: gesture.scale)
    }
    
    fileprivate func didCancelPinchOnPhoto() {
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
    
    fileprivate func presentLightBoxViewController(sourceImageView: UIImageView, useSourceImageViewAsProxy : Bool) {
        let lightboxViewController = DetailFullScreenImageViewController(photo: photo)
        let lightboxTransitioningDelegate = DetailLightBoxPresentationController(presentingViewController: self, presentedViewController: lightboxViewController, photo: photo, sourceImageView: sourceImageView, useSourceImageViewAsProxy: useSourceImageViewAsProxy)
        lightboxViewController.modalPresentationStyle = .custom
        lightboxViewController.transitioningDelegate = lightboxTransitioningDelegate
        
        self.present(lightboxViewController, animated: true, completion: nil)
    }
}
