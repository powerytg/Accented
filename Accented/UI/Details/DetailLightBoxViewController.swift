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
    func lightBoxSelectionDidChange(_ selectedIndex : Int)
}

class DetailLightBoxViewController: DeckViewController, DeckViewControllerDataSource, DetailLightBoxAnimation, UIGestureRecognizerDelegate {

    // Initial selected photo
    var initialSelectedPhoto : PhotoModel
    
    // Photo collection
    var photoCollection = [PhotoModel]()
    
    // Initial selected view controller
    fileprivate var initialSelectedViewController : DetailLightBoxImageViewController!

    // Initial size
    fileprivate var initialSize : CGSize
    
    // Back button
    fileprivate var backButton = UIButton(type: .custom)
    
    // Event delegate
    weak var delegate : DetailLightBoxViewControllerDelegate?
    
    init(selectedPhoto : PhotoModel, photoCollection : [PhotoModel], initialSize : CGSize) {
        self.initialSize = initialSize
        self.initialSelectedPhoto = selectedPhoto
        self.photoCollection = photoCollection
        let initialSelectedIndex = photoCollection.index(of: initialSelectedPhoto)!
        
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
        backButton.setImage(UIImage(named: "DetailBackButton"), for: UIControlState())
        backButton.addTarget(self, action: #selector(backButtonDidTap(_:)), for: .touchUpInside)
        backButton.sizeToFit()

        // Setup data source
        self.dataSource = self
        initialSelectedViewController = cacheController.selectedCard as! DetailLightBoxImageViewController
        
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
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async { [weak self] in
            self?.layoutController.containerSize = size
            
            // Notify each of the child cards to update their frames
            for card in self!.cacheController.cachedCards {
                card.viewWillTransition(to: size, with: coordinator)
            }
        }
    }

    // MARK: - DeckViewControllerDataSource
    
    func numberOfCards() -> Int {
        return photoCollection.count
    }
    
    func cardForItemIndex(_ itemIndex: Int) -> CardViewController {
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
        contentView.isHidden = true
    }
    
    func lightboxTransitionDidFinish() {
        contentView.isHidden = false
        self.view.backgroundColor = UIColor.black
    }
    
    func performLightBoxTransition() {
        // Do nothing
    }
    
    func desitinationRectForSelectedLightBoxPhoto(_ photo: PhotoModel) -> CGRect {
        return initialSelectedViewController.desitinationRectForProxyView(photo)
    }
    
    // Events
    
    @objc fileprivate func backButtonDidTap(_ sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let selectedCard = cacheController.selectedCard as! DetailLightBoxImageViewController
        return selectedCard.shouldAllowExternalPanGesture()
    }
    
}
