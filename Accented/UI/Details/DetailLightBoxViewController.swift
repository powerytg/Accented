//
//  DetailLightBoxViewController.swift
//  Accented
//
//  Created by Tiangong You on 8/8/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailLightBoxViewController: DeckViewController, DeckViewControllerDataSource, DetailLightBoxAnimation {

    // Initial selected photo
    var initialSelectedPhoto : PhotoModel
    
    // Photo collection
    var photoCollection = [PhotoModel]()
    
    // Initial selected view controller
    private var initialSelectedViewController : DetailLightBoxImageViewController!

    // Initial size
    private var initialSize : CGSize
    
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
        
        // Setup data source
        self.dataSource = self
        initialSelectedViewController = cacheController.selectedCardViewController as! DetailLightBoxImageViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        layoutController.containerSize = size        
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
    }
    
    // MARK: - Lightbox animation
    
    func lightBoxTransitionWillBegin() {
        // Initially hide all the conent
        contentView.hidden = true
        
        initialSelectedViewController.entranceAnimationWillBegin()
    }
    
    func lightboxTransitionDidFinish() {
        contentView.hidden = false
        initialSelectedViewController.entranceAnimationDidFinish()
        self.view.backgroundColor = UIColor.blackColor()
    }
    
    func performLightBoxTransition() {
        initialSelectedViewController.performEntranceAnimation()
    }
    
    func desitinationRectForSelectedLightBoxPhoto(photo: PhotoModel) -> CGRect {
        return initialSelectedViewController.desitinationRectForProxyView(photo)
    }

}
