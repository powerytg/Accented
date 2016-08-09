//
//  DetailLightBoxViewController.swift
//  Accented
//
//  Created by Tiangong You on 8/8/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailLightBoxViewController: DeckViewController, DeckViewControllerDataSource, DetailEntranceProxyAnimation {

    // Initial selected photo
    var initialSelectedPhoto : PhotoModel
    
    // Photo collection
    var photoCollection = [PhotoModel]()
    
    // Source image view from entrance transition
    var sourceImageView : UIImageView
    
    // Initial selected view controller
    private var initialSelectedViewController : DetailLightBoxImageViewController!

    init(selectedPhoto : PhotoModel, photoCollection : [PhotoModel], sourceImageView : UIImageView) {
        self.sourceImageView = sourceImageView
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
        
        // Setup data source
        self.dataSource = self
        initialSelectedViewController = cacheController.selectedCardViewController as! DetailLightBoxImageViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    // MARK: - Animations
    
    func entranceAnimationWillBegin() {
        initialSelectedViewController.entranceAnimationWillBegin()
    }
    
    func performEntranceAnimation() {
        initialSelectedViewController.performEntranceAnimation()
    }
    
    func entranceAnimationDidFinish() {
        initialSelectedViewController.entranceAnimationDidFinish()
        self.view.backgroundColor = UIColor.blackColor()
    }
    
    func desitinationRectForProxyView(photo: PhotoModel) -> CGRect {
        return initialSelectedViewController.desitinationRectForProxyView(photo)
    }

}
