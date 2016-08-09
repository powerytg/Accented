//
//  DetailGalleryViewController.swift
//  Accented
//
//  Created by Tiangong You on 8/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailGalleryViewController: DeckViewController, DeckViewControllerDataSource, DetailEntranceProxyAnimation, DetailViewControllerDelegate {

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
    
    @objc private func backButtonDidTap(sender : UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
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

    // MARK: - Animations
    
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
    }
    
    func desitinationRectForProxyView(photo: PhotoModel) -> CGRect {
        return initialSelectedViewController.desitinationRectForProxyView(photo)
    }
    
    // MARK: - DetailViewControllerDelegate
    
    func detailViewDidScroll(offset: CGPoint, contentSize: CGSize) {
        backgroundView.applyScrollingAnimation(offset, contentSize: contentSize)
    }
    
    // MARK: - DetailPhotoSectionViewDelegate

    func didTapOnPhoto(photo: PhotoModel, sourceImageView: UIImageView) {
        let lightboxViewController = DetailLightBoxViewController(selectedPhoto: photo, photoCollection: photoCollection, sourceImageView: sourceImageView)
        let transitioningDelegate = DetailLightBoxPresentationController(photo: photo, sourceImageView: sourceImageView)
        lightboxViewController.modalPresentationStyle = .Custom
        lightboxViewController.transitioningDelegate = transitioningDelegate
        
        self.presentViewController(lightboxViewController, animated: true, completion: nil)
    }
}
