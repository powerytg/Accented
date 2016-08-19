//
//  DetailLightBoxViewController.swift
//  Accented
//
//  Created by Tiangong You on 8/8/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

// Event delegate for DeailLightBoxViewController
protocol DetailLightBoxViewControllerDelegate : NSObjectProtocol {
    func lightBoxSelectionDidChange(selectedIndex : Int)
}

class DetailLightBoxViewController: DeckViewController, DeckViewControllerDataSource, DetailLightBoxAnimation, UIGestureRecognizerDelegate {

    // Initial selected photo
    var initialSelectedPhoto : PhotoModel
    
    // Photo collection
    var photoCollection = [PhotoModel]()
    
    // Initial selected view controller
    private var initialSelectedViewController : DetailLightBoxImageViewController!

    // Initial size
    private var initialSize : CGSize
    
    // Back button
    private var backButton = UIButton(type: .Custom)
    
    // Event delegate
    weak var delegate : DetailLightBoxViewControllerDelegate?
    
    init(selectedPhoto : PhotoModel, photoCollection : [PhotoModel], initialSize : CGSize) {
        self.initialSize = initialSize
        self.initialSelectedPhoto = selectedPhoto
        self.photoCollection = photoCollection
        let initialSelectedIndex = photoCollection.indexOf(initialSelectedPhoto)!
        
        super.init(initialSelectedIndex: initialSelectedIndex)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup layout
        layoutController.gap = 0
        layoutController.visibleRightChildWidth = 0
        layoutController.containerSize = initialSize
        
        // Back button
        self.view.addSubview(backButton)
        backButton.setImage(UIImage(named: "DetailBackButton"), forState: .Normal)
        backButton.addTarget(self, action: #selector(backButtonDidTap(_:)), forControlEvents: .TouchUpInside)
        backButton.sizeToFit()

        // Setup data source
        self.dataSource = self
        initialSelectedViewController = cacheController.selectedCardViewController as! DetailLightBoxImageViewController
        
        // Setup pan gesture delegate
        panGesture.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var f = backButton.frame
        f.origin.x = 10
        f.origin.y = 30
        backButton.frame = f
    }
    
    // MARK: - Orientation
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            self?.layoutController.containerSize = size
            
            // Notify each of the child cards to update their frames
            for card in (self?.cacheController.cachedViewControllers)! {
                card.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
            }
        }
    }

    // MARK: - DeckViewControllerDataSource
    
    func numberOfCards() -> Int {
        return photoCollection.count
    }
    
    func cardForItemIndex(itemIndex: Int) -> CardViewController {
        var card = getRecycledCardViewController() as? DetailLightBoxImageViewController
        if card == nil {
            card = DetailLightBoxImageViewController()
        }
        
        card!.photo = photoCollection[itemIndex]
        
        return card!
    }
    
    override func selectedIndexDidChange() {
        super.selectedIndexDidChange()
        delegate?.lightBoxSelectionDidChange(self.selectedIndex)
    }
    
    // MARK: - Lightbox animation
    
    func lightBoxTransitionWillBegin() {
        // Initially hide all the conent
        contentView.hidden = true
    }
    
    func lightboxTransitionDidFinish() {
        contentView.hidden = false
        self.view.backgroundColor = UIColor.blackColor()
    }
    
    func performLightBoxTransition() {
        // Do nothing
    }
    
    func desitinationRectForSelectedLightBoxPhoto(photo: PhotoModel) -> CGRect {
        return initialSelectedViewController.desitinationRectForProxyView(photo)
    }
    
    // Events
    
    @objc private func backButtonDidTap(sender : UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let selectedCard = cacheController.selectedCardViewController as! DetailLightBoxImageViewController
        return selectedCard.shouldAllowExternalPanGesture()
    }
    
}
