//
//  DetailGalleryViewController.swift
//  Accented
//
//  Created by Tiangong You on 8/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailGalleryViewController: DeckViewController, DeckViewControllerDataSource, DetailEntranceProxyAnimation, DetailViewControllerDelegate, DetailLightBoxAnimation, DetailLightBoxViewControllerDelegate {

    // Initial selected photo
    var initialSelectedPhoto : PhotoModel
    
    // Photo collection
    var photoCollection = [PhotoModel]()
    
    // Source image view from entrance transition
    var sourceImageView : UIImageView
    
    // Background view
    private var backgroundView : DetailBackgroundView!
    
    // Initial selected view controller
    private var initialSelectedViewController : DetailViewController!
    
    // Back button
    private var backButton = UIButton(type: .Custom)
    
    // Temporary proxy image view when pinching on the main photo view
    private var pinchProxyImageView : UIImageView?
    
    // Selected detail view controller
    private var selectedDetailViewController : DetailViewController? {
        return cacheController.selectedCardViewController as? DetailViewController
    }
    
    init(context : DetailNavigationContext) {
        self.sourceImageView = context.sourceImageView
        self.initialSelectedPhoto = context.initialSelectedPhoto
        self.photoCollection = context.photoCollection
        let initialSelectedIndex = photoCollection.indexOf(initialSelectedPhoto)!
        
        super.init(initialSelectedIndex: initialSelectedIndex)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Background view
        self.automaticallyAdjustsScrollViewInsets = false
        backgroundView = DetailBackgroundView(frame: self.view.bounds)
        self.view.insertSubview(backgroundView, atIndex: 0)
        
        // Back button
        self.view.addSubview(backButton)
        backButton.setImage(UIImage(named: "DetailBackButton"), forState: .Normal)
        backButton.addTarget(self, action: #selector(backButtonDidTap(_:)), forControlEvents: .TouchUpInside)
        backButton.sizeToFit()
        
        // Setup data source
        self.cacheInitializationPolicy = .Deferred
        self.dataSource = self
        initialSelectedViewController = cacheController.selectedCardViewController as! DetailViewController
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        backgroundView.frame = self.view.bounds
        
        var f = backButton.frame
        f.origin.x = 10
        f.origin.y = 30
        backButton.frame = f
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Orientation
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        guard self.presentedViewController == nil else { return }
        guard self.selectedDetailViewController != nil else { return }
        guard self.selectedDetailViewController!.photo != nil else { return }
        
        let lightboxViewController = DetailLightBoxViewController(selectedPhoto: selectedDetailViewController!.photo!, photoCollection: photoCollection, initialSize: size)
        lightboxViewController.delegate = self
        self.presentViewController(lightboxViewController, animated: false, completion: nil)
    }

    // MARK: - DeckViewControllerDataSource
    
    func numberOfCards() -> Int {
        return photoCollection.count
    }
    
    func cardForItemIndex(itemIndex: Int) -> CardViewController {
        var card = getRecycledCardViewController() as? DetailViewController
        if card == nil {
            card = DetailViewController(sourceImageView: sourceImageView, maxWidth: layoutController.cardWidth)
        }
        
        card!.photo = photoCollection[itemIndex]
        card!.delegate = self
        
        return card!
    }

    override func selectedIndexDidChange() {
        super.selectedIndexDidChange()
        backgroundView.resetScrollingAnimation()
    }

    // MARK: - Entrance animation
    
    func entranceAnimationWillBegin() {
        backgroundView.entranceAnimationWillBegin()        
        initialSelectedViewController.entranceAnimationWillBegin()
    }
    
    func performEntranceAnimation() {
        backgroundView.performEntranceAnimation()
        initialSelectedViewController.performEntranceAnimation()
    }
    
    func entranceAnimationDidFinish() {
        backgroundView.entranceAnimationDidFinish()
        initialSelectedViewController.entranceAnimationDidFinish()
        
        // Create the sibling cards and perform their sliding animation
        cacheController.initializeSelectedCardSiblings()
    }
    
    func desitinationRectForProxyView(photo: PhotoModel) -> CGRect {
        return initialSelectedViewController.desitinationRectForProxyView(photo)
    }
    
    override func initialSiblingCardsDidFinishInitialization() {
        // After the entrance animation, create the sibling cards
        for card in cacheController.leftVisibleCardViewControllers {
            if !contentView.subviews.contains(card.view) {
                card.view.alpha = 0
                contentView.addSubview(card.view)
            }
        }
        
        for card in cacheController.rightVisibleCardViewControllers {
            if !contentView.subviews.contains(card.view) {
                card.view.alpha = 0
                contentView.addSubview(card.view)
            }
        }
        
        updateVisibleCardFrames()
        
        // Make the left card visible
        if cacheController.leftVisibleCardViewControllers.count > 0 {
            cacheController.leftVisibleCardViewControllers[0].view.alpha = 1
        }
        
        // Slide in the most adjacent right card
        if cacheController.rightVisibleCardViewControllers.count > 0 {
            let rightCard = cacheController.rightVisibleCardViewControllers[0].view
            rightCard.transform = CGAffineTransformMakeTranslation(0, 100)
            
            UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: { 
                rightCard.alpha = 1
                rightCard.transform = CGAffineTransformIdentity
            }) { [weak self] (finished) in
                // Make the rest of siblings visible
                if self?.cacheController.rightVisibleCardViewControllers.count > 1 {
                    self?.cacheController.rightVisibleCardViewControllers[1].view.alpha = 1
                }
            }
        }
    }
    
    // MARK: - Light box animation
    
    func lightBoxTransitionWillBegin() {
        selectedDetailViewController?.lightBoxTransitionWillBegin()
    }
    
    func lightboxTransitionDidFinish() {
        selectedDetailViewController?.lightboxTransitionDidFinish()
        self.view.alpha = 1
    }
    
    func performLightBoxTransition() {
        selectedDetailViewController?.performLightBoxTransition()
        
        UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1) { [weak self] in
            self?.view.alpha = 0
        }
    }
    
    func desitinationRectForSelectedLightBoxPhoto(photo: PhotoModel) -> CGRect {
        return selectedDetailViewController!.desitinationRectForSelectedLightBoxPhoto(photo)
    }

    // MARK: - DetailViewControllerDelegate
    
    func detailViewDidScroll(offset: CGPoint, contentSize: CGSize) {
        backgroundView.applyScrollingAnimation(offset, contentSize: contentSize)
    }
    
    // MARK: - DetailPhotoSectionViewDelegate

    func didTapOnPhoto(photo: PhotoModel, sourceImageView: UIImageView) {
        self.presentLightBoxViewController(photo, sourceImageView: sourceImageView, useSourceImageViewAsProxy: false)
    }
    
    func didStartPinchOnPhoto(photo: PhotoModel, sourceImageView: UIImageView) {
        // Create a proxy image view for the pinch action
        pinchProxyImageView = UIImageView(image: sourceImageView.image)
        pinchProxyImageView!.contentMode = sourceImageView.contentMode
        let proxyImagePosition = sourceImageView.convertPoint(sourceImageView.bounds.origin, toView: self.view)
        pinchProxyImageView!.frame = CGRectMake(proxyImagePosition.x, proxyImagePosition.y, CGRectGetWidth(sourceImageView.bounds), CGRectGetHeight(sourceImageView.bounds))
        self.view.addSubview(pinchProxyImageView!)

        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: { [weak self] in
            self?.contentView.alpha = 0
            self?.backgroundView.alpha = 0
            }, completion: nil)
    }
    
    func didEndPinchOnPhoto(photo: PhotoModel, sourceImageView: UIImageView) {
        // Use the temporary pinch proxy image view as the source view for lightbox transition
        self.presentLightBoxViewController(photo, sourceImageView: pinchProxyImageView!, useSourceImageViewAsProxy: true)
        pinchProxyImageView?.removeFromSuperview()
    }
    
    func photoDidReceivePinch(photo: PhotoModel, sourceImageView: UIImageView, gesture: UIPinchGestureRecognizer) {
        pinchProxyImageView?.transform = CGAffineTransformMakeScale(gesture.scale, gesture.scale)
    }
    
    func didCancelPinchOnPhoto(photo: PhotoModel, sourceImageView: UIImageView) {
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: { [weak self] in
            self?.pinchProxyImageView?.transform = CGAffineTransformIdentity
            self?.backgroundView.alpha = 1
            self?.contentView.alpha = 1
            }) { [weak self] (finished) in
                sourceImageView.hidden = false
                self?.pinchProxyImageView?.removeFromSuperview()
                self?.pinchProxyImageView = nil
        }
    }

    // MARK: - DetailLightBoxViewControllerDelegate
    
    func lightBoxSelectionDidChange(selectedIndex: Int) {
        // Sync self selection with the light box
        if selectedIndex < self.selectedIndex {
            scrollToRight(false)
        } else {
            scrollToLeft(false)
        }
    }
    
    // MARK: - Events
    
    @objc private func backButtonDidTap(sender : UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Private
    private func presentLightBoxViewController(photo: PhotoModel, sourceImageView: UIImageView, useSourceImageViewAsProxy : Bool) {
        let lightboxViewController = DetailLightBoxViewController(selectedPhoto: photo, photoCollection: photoCollection, initialSize: self.view.bounds.size)
        let transitioningDelegate = DetailLightBoxPresentationController(presentingViewController: self, presentedViewController: lightboxViewController, photo: photo, sourceImageView: sourceImageView, useSourceImageViewAsProxy: useSourceImageViewAsProxy)
        lightboxViewController.modalPresentationStyle = .Custom
        lightboxViewController.transitioningDelegate = transitioningDelegate
        lightboxViewController.delegate = self
        
        self.presentViewController(lightboxViewController, animated: true, completion: nil)
    }
}
