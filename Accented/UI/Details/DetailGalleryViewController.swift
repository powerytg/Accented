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
    fileprivate var backgroundView : DetailBackgroundView!
    
    // Initial selected view controller
    fileprivate var initialSelectedViewController : DetailViewController!
    
    // Back button
    fileprivate var backButton = UIButton(type: .custom)
    
    // Temporary proxy image view when pinching on the main photo view
    fileprivate var pinchProxyImageView : UIImageView?
    
    // Selected detail view controller
    fileprivate var selectedDetailViewController : DetailViewController? {
        return cacheController.selectedCard as? DetailViewController
    }
    
    // Cache controller
    fileprivate var detailCacheController = DetailCacheController()
    
    init(context : DetailNavigationContext) {
        self.sourceImageView = context.sourceImageView
        self.initialSelectedPhoto = context.initialSelectedPhoto
        self.photoCollection = context.photoCollection

        let initialSelectedIndex = photoCollection.index(of: initialSelectedPhoto)!        
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
        self.view.insertSubview(backgroundView, at: 0)
        
        // Back button
        self.view.addSubview(backButton)
        backButton.setImage(UIImage(named: "DetailBackButton"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonDidTap(_:)), for: .touchUpInside)
        backButton.sizeToFit()
        
        // Setup data source
        self.cacheInitializationPolicy = .deferred
        self.dataSource = self
        initialSelectedViewController = cacheController.selectedCard as! DetailViewController
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
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard self.presentedViewController == nil else { return }
        guard self.selectedDetailViewController != nil else { return }
        guard self.selectedDetailViewController!.photo != nil else { return }
        
        // Transition to lightbox only if we're in landscape mode
        guard size.width > size.height else { return }
        
        // We cannot present the lightbox immediately since the transition will break
        // The workaround is to animate along with the coordinator and perform the modal presentation upon animation completion
        coordinator.animate(alongsideTransition: { (context) in
            self.view.alpha = 0
        }, completion: { (context) in
            self.presentLightBoxViewController(self.selectedDetailViewController!.photo!, sourceImageView: self.selectedDetailViewController!.heroPhotoView, useSourceImageViewAsProxy: false)
        })
    }

    // MARK: - DeckViewControllerDataSource
    
    func numberOfCards() -> Int {
        return photoCollection.count
    }
    
    func cardForItemIndex(_ itemIndex: Int) -> CardViewController {
        var card = getRecycledCardViewController() as? DetailViewController
        if card == nil {
            card = DetailViewController(sourceImageView: sourceImageView, maxWidth: layoutController.cardWidth, cacheController: detailCacheController)
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
    
    func desitinationRectForProxyView(_ photo: PhotoModel) -> CGRect {
        return initialSelectedViewController.desitinationRectForProxyView(photo)
    }
    
    override func deferredSiblingCardsDidFinishInitialization() {
        super.deferredSiblingCardsDidFinishInitialization()
        
        // Slide in the most adjacent right card
        if let rightCard = cacheController.rightCard {
            let offset = layoutController.offsetForCardAtIndex(rightCard.indexInDataSource, selectedCardIndex: selectedIndex)
            rightCard.view.alpha = 0
            rightCard.view.transform = CGAffineTransform(translationX: offset, y: 100)
            
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
                rightCard.view.alpha = 1
                rightCard.view.transform = CGAffineTransform(translationX: offset, y: 0)
            }, completion: nil)
        }
    }
    
    // MARK: - Light box animation
    
    func lightBoxTransitionWillBegin() {
        selectedDetailViewController?.lightBoxTransitionWillBegin()
    }
    
    func lightboxTransitionDidFinish() {
        selectedDetailViewController?.lightboxTransitionDidFinish()
        self.view.alpha = 1
        self.contentView.alpha = 1
        self.backgroundView.alpha = 1
    }
    
    func performLightBoxTransition() {
        selectedDetailViewController?.performLightBoxTransition()
        
        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) { [weak self] in
            self?.view.alpha = 0
        }
    }
    
    func desitinationRectForSelectedLightBoxPhoto(_ photo: PhotoModel) -> CGRect {
        return selectedDetailViewController!.desitinationRectForSelectedLightBoxPhoto(photo)
    }

    // MARK: - DetailViewControllerDelegate
    
    func detailViewDidScroll(_ offset: CGPoint, contentSize: CGSize) {
        backgroundView.applyScrollingAnimation(offset, contentSize: contentSize)
    }
    
    // MARK: - DetailPhotoSectionViewDelegate

    func didTapOnPhoto(_ photo: PhotoModel, sourceImageView: UIImageView) {
        self.presentLightBoxViewController(photo, sourceImageView: sourceImageView, useSourceImageViewAsProxy: false)
    }
    
    func didStartPinchOnPhoto(_ photo: PhotoModel, sourceImageView: UIImageView) {
        // Create a proxy image view for the pinch action
        pinchProxyImageView = UIImageView(image: sourceImageView.image)
        pinchProxyImageView!.contentMode = sourceImageView.contentMode
        let proxyImagePosition = sourceImageView.convert(sourceImageView.bounds.origin, to: self.view)
        pinchProxyImageView!.frame = CGRect(x: proxyImagePosition.x, y: proxyImagePosition.y, width: sourceImageView.bounds.width, height: sourceImageView.bounds.height)
        self.view.addSubview(pinchProxyImageView!)

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.contentView.alpha = 0
            self?.backgroundView.alpha = 0
            }, completion: nil)
    }
    
    func didEndPinchOnPhoto(_ photo: PhotoModel, sourceImageView: UIImageView) {
        // Use the temporary pinch proxy image view as the source view for lightbox transition
        self.presentLightBoxViewController(photo, sourceImageView: pinchProxyImageView!, useSourceImageViewAsProxy: true)
        pinchProxyImageView?.removeFromSuperview()
    }
    
    func photoDidReceivePinch(_ photo: PhotoModel, sourceImageView: UIImageView, gesture: UIPinchGestureRecognizer) {
        pinchProxyImageView?.transform = CGAffineTransform(scaleX: gesture.scale, y: gesture.scale)
    }
    
    func didCancelPinchOnPhoto(_ photo: PhotoModel, sourceImageView: UIImageView) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.pinchProxyImageView?.transform = CGAffineTransform.identity
            self?.backgroundView.alpha = 1
            self?.contentView.alpha = 1
            }) { [weak self] (finished) in
                sourceImageView.isHidden = false
                self?.pinchProxyImageView?.removeFromSuperview()
                self?.pinchProxyImageView = nil
        }
    }

    // MARK: - DetailLightBoxViewControllerDelegate
    
    func lightBoxSelectionDidChange(_ selectedIndex: Int) {
        // Sync self selection with the light box
        if selectedIndex < self.selectedIndex {
            scrollToRight(false)
        } else {
            scrollToLeft(false)
        }
    }
    
    // MARK: - Events
    
    @objc func backButtonDidTap(_ sender : UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private
    fileprivate func presentLightBoxViewController(_ photo: PhotoModel, sourceImageView: UIImageView, useSourceImageViewAsProxy : Bool) {
        let lightboxViewController = DetailLightBoxViewController(selectedPhoto: photo, photoCollection: photoCollection, initialSize: self.view.bounds.size)
        let lightboxTransitioningDelegate = DetailLightBoxPresentationController(presentingViewController: self, presentedViewController: lightboxViewController, photo: photo, sourceImageView: sourceImageView, useSourceImageViewAsProxy: useSourceImageViewAsProxy)
        lightboxViewController.modalPresentationStyle = .custom
        lightboxViewController.transitioningDelegate = lightboxTransitioningDelegate
        lightboxViewController.delegate = self
        
        self.present(lightboxViewController, animated: true, completion: nil)
    }
}
