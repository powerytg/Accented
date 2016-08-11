//
//  DeckViewController.swift
//  Accented
//
//  Created by You, Tiangong on 8/5/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DeckViewController: UIViewController, DeckLayoutControllerDelegate, DeckCacheControllerDelegate {

    // Reference to the data source
    weak var dataSource : DeckViewControllerDataSource? {
        didSet {
            // Remove all previous cards
            removeAllCards()
            
            cacheController.dataSource = dataSource
            layoutController.dataSource = dataSource
            
            // Re-create cache and layout
            if let ds = dataSource {
                totalCardCount = ds.numberOfCards()
                cacheController.initializeCache(selectedIndex)
                updateVisibleCardFrames()
            }
        }
    }
    
    // Cache controller
    var cacheController : DeckCacheController
    
    // Layout controller
    var layoutController : DeckLayoutController
    
    // Selected index
    var selectedIndex = 0
    
    // Previous selected index
    private var previousSelectedIndex = 0
    
    // Total number of cards
    private var totalCardCount = 0
    
    // Content view
    var contentView = UIView()
    
    init(initialSelectedIndex : Int = 0) {
        self.selectedIndex = initialSelectedIndex
        self.previousSelectedIndex = initialSelectedIndex
        self.cacheController = DeckCacheController()
        self.layoutController = DeckLayoutController()
        super.init(nibName: nil, bundle: nil)
        
        // Initialization
        self.automaticallyAdjustsScrollViewInsets = false
        self.layoutController.delegate = self
        self.cacheController.delegate = self
        
        // Gestures
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didReceivePanGesture(_:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the content container
        self.view.addSubview(contentView)
        
        // Update container size for the layout controller
        layoutController.containerSize = self.view.bounds.size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Card management
    
    func getRecycledCardViewController() -> CardViewController? {
        return cacheController.getRecycledCardViewController()
    }
    
    private func removeAllCards() {
        for card in self.contentView.subviews {
            card.removeFromSuperview()
        }
    }
    
    // Invoked when the selected index has changed
    func selectedIndexDidChange() {
        for card in cacheController.visibleCardViewControllers {
            card.cardSelectionDidChange(card == cacheController.selectedCardViewController)
        }
    }
    
    func updateVisibleCardFrames() {
        guard dataSource != nil else { return }
        
        // Layout visible cards
        for (index, card) in cacheController.leftVisibleCardViewControllers.enumerate() {
            card.view.frame = layoutController.leftVisibleCardFrames[index]
        }
        
        if let selectedCard = cacheController.selectedCardViewController {
            selectedCard.view.frame = layoutController.selectedCardFrame
        }
        
        for (index, card) in cacheController.rightVisibleCardViewControllers.enumerate() {
            card.view.frame = layoutController.rightVisibleCardFrames[index]
        }
    }
    
    // MARK: - Gestures
    func didReceivePanGesture(gesture : UIPanGestureRecognizer) {
        switch gesture.state {
        case .Began:
            for view in self.contentView.subviews {
                view.hidden = false
            }
        case .Ended:
            panGestureDidEnd(gesture)
        case .Changed:
            panGestureDidChange(gesture)
        default: break
        }
    }
    
    private func panGestureDidChange(gesture : UIPanGestureRecognizer) {
        let tx = gesture.translationInView(gesture.view).x
        contentView.transform = CGAffineTransformMakeTranslation(tx, 0)
        
        for card in cacheController.visibleCardViewControllers {
            card.cardDidReceivePanGesture(tx, cardWidth: layoutController.cardWidth)
        }
    }
    
    private func panGestureDidEnd(gesture : UIPanGestureRecognizer) {
        let velocity = gesture.velocityInView(gesture.view).x        
        if velocity > 0 {
            scrollToRight(true)
        } else {
            scrollToLeft(true)
        }
    }
    
    func scrollToLeft(animated : Bool) {
        // Scroll to left
        if selectedIndex < totalCardCount - 1 {
            selectedIndex += 1
            cacheController.scrollToLeft()
        }

        if animated {
            performScrollingAnimation()
        } else {
            self.contentView.transform = CGAffineTransformIdentity
            self.updateVisibleCardFrames()
            self.selectedIndexDidChange()
        }
    }
    
    func scrollToRight(animated : Bool) {
        // Scroll to right
        if selectedIndex > 0 {
            selectedIndex -= 1
            cacheController.scrollToRight()
        }
        
        if animated {
            performScrollingAnimation()
        } else {
            self.contentView.transform = CGAffineTransformIdentity
            self.updateVisibleCardFrames()
            self.selectedIndexDidChange()
        }
    }
    
    private func performScrollingAnimation() {
        UIView.animateWithDuration(0.2, delay: 0, options: [.CurveLinear], animations: { [weak self] in
            self?.contentView.transform = CGAffineTransformIdentity
            self?.updateVisibleCardFrames()
            
            for card in (self?.cacheController.visibleCardViewControllers)! {
                card.performCardTransitionAnimation()
            }
            
        }) { [weak self] (completed) in
            self?.selectedIndexDidChange()
        }
    }
    
    // MARK: - DeckLayoutControllerDelegate
    
    internal func deckLayoutDidChange() {
        contentView.frame = CGRectMake(0, 0, layoutController.contentSize.width, layoutController.contentSize.height)
        updateVisibleCardFrames()
    }
    
    // MARK: - DeckCacheControllerDelegate
    
    func cardCacheDidChange() {
        for card in cacheController.leftVisibleCardViewControllers {
            if !contentView.subviews.contains(card.view) {
                contentView.addSubview(card.view)
            }
        }
        
        if let selectedCard = cacheController.selectedCardViewController {
            if !contentView.subviews.contains(selectedCard.view) {
                contentView.addSubview(selectedCard.view)
            }
        }
        
        for card in cacheController.rightVisibleCardViewControllers {
            if !contentView.subviews.contains(card.view) {
                contentView.addSubview(card.view)
            }
        }
    }
    
    func initialSiblingCardsDidFinishInitialization() {
        for card in cacheController.leftVisibleCardViewControllers {
            if !contentView.subviews.contains(card.view) {
                contentView.addSubview(card.view)
            }
        }
        
        for card in cacheController.rightVisibleCardViewControllers {
            if !contentView.subviews.contains(card.view) {
                contentView.addSubview(card.view)
            }
        }
        
        updateVisibleCardFrames()
    }
}
