//
//  DetailGalleryViewController.swift
//  Accented
//
//  Created by Tiangong You on 8/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailGalleryViewController: DeckViewController, DeckViewControllerDataSource, DetailEntranceProxyAnimation {

    // Initial selected photo
    var initialSelectedPhoto : PhotoModel
    
    // Photo collection
    var photoCollection = [PhotoModel]()
    
    // Source image view from entrance transition
    var sourceImageView : UIImageView
    
    // Background view
    private var backgroundView = DetailBackgroundView(frame: CGRectZero)
    
    // Initial selected view controller
    private var initialSelectedViewController : DetailViewController!
    
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
        self.view.insertSubview(backgroundView, atIndex: 0)
        
        // Setup data source
        self.dataSource = self
        initialSelectedViewController = cacheController.selectedCardViewController as! DetailViewController
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        backgroundView.frame = self.view.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        return card!
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
}
