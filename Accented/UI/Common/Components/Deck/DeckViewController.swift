//
//  DeckViewController.swift
//  Accented
//
//  Created by You, Tiangong on 8/5/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

// Cache initializatio policy
enum DeckViewControllerCacheInitializationPolicy {
    // The cache will be fully initialized
    case Default
    
    // Only the selected card will be initialized
    case Deferred
}

class DeckViewController: UIViewController, DeckLayoutControllerDelegate, DeckCacheControllerDelegate {

    // Cache initialization policy
    var cacheInitializationPolicy : DeckViewControllerCacheInitializationPolicy = .Default
    
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
                
                if cacheInitializationPolicy == .Default {
                    cacheController.initializeCache(selectedIndex)
                } else {
                    cacheController.initializeSelectedCard(selectedIndex)
                }
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
    
    // Animation configurations
    private var animationParams = DeckAnimationParams()
    
    // Pan gesture
    var panGesture : UIPanGestureRecognizer!
    
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
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(didReceivePanGesture(_:)))
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
        for card in cacheController.cachedCards {
            card.cardSelectionDidChange(card.indexInDataSource == selectedIndex)
        }
    }
    
    // Update the frames for the selected view controller as well its siblings
    func updateVisibleCardFrames(updateOffScreenCards : Bool) {
        guard dataSource != nil else { return }
        
        for card in cacheController.cachedCards {
            if updateOffScreenCards {
                layoutCard(card)
            } else if card.withinVisibleRange {
                layoutCard(card)
            }
        }
    }
    
    // MARK: - Gestures
    func didReceivePanGesture(gesture : UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended:
            panGestureDidEnd(gesture)
        case .Changed:
            panGestureDidChange(gesture)
        case .Cancelled:
            cancelScrolling()
        default: break
        }
    }
    
    private func panGestureDidChange(gesture : UIPanGestureRecognizer) {
        let tx = gesture.translationInView(gesture.view).x
        for card in cacheController.cachedCards {
            if card.withinVisibleRange {
                let cardOffset = layoutController.offsetForCardAtIndex(card.indexInDataSource, selectedCardIndex: selectedIndex)
                card.view.transform = CGAffineTransformMakeTranslation(cardOffset + tx, 0)
            }
        }
    }
    
    private func panGestureDidEnd(gesture : UIPanGestureRecognizer) {
        let velocity = gesture.velocityInView(gesture.view).x
        let tx = gesture.translationInView(gesture.view).x
        var shouldConfirm : Bool
        
        if (tx >= 0 && velocity <= 0) || (tx <= 0 && velocity >= 0) {
            // If the velocity and translation differs in direction, cancel the gesture if translation distance is sufficient enough
            shouldConfirm = !(abs(tx) >= animationParams.cancelTriggeringTranslation)
        } else {
            if abs(velocity) >= animationParams.scrollTriggeringVelocity {
                // If the velocity is sufficient enough, confirm the gesture regardlessly
                shouldConfirm = true
            } else {
                // Otherwise, only confirm if translation distance is sufficient enough
                shouldConfirm = (abs(tx) >= animationParams.cancelTriggeringTranslation)
            }
        }
        
        if shouldConfirm {
            if velocity > 0 {
                scrollToRight(true)
            } else {
                scrollToLeft(true)
            }
        } else {
            cancelScrolling()
        }        
    }
    
    // MARK: - Scrolling
    
    // Scroll to the next item
    func scrollToLeft(animated : Bool) {
        // Scroll to left
        if selectedIndex < totalCardCount - 1 {
            selectedIndex += 1
            cacheController.scrollToLeft()
        }

        if animated {
            performScrollingAnimation()
        } else {
            self.updateVisibleCardFrames(true)
            self.selectedIndexDidChange()
        }
    }
    
    // Scroll to the previous item
    func scrollToRight(animated : Bool) {
        // Scroll to right
        if selectedIndex > 0 {
            selectedIndex -= 1
            cacheController.scrollToRight()
        }
        
        if animated {
            performScrollingAnimation()
        } else {
            cacheController.scrollingDidFinish()
            self.updateVisibleCardFrames(true)
            self.selectedIndexDidChange()
        }
    }
    
    // Cancel the scrolling and reset to the current position
    private func cancelScrolling() {
        UIView.animateWithDuration(0.2, delay: 0, options: [.CurveEaseOut], animations: { [weak self] in
            self?.updateVisibleCardFrames(false)
            }, completion: nil)
    }
    
    // Scroll to the selected view controller
    private func performScrollingAnimation() {
        UIView.animateWithDuration(0.2, delay: 0, options: [.CurveEaseOut], animations: { [weak self] in
            self?.updateVisibleCardFrames(false)
            
        }) { [weak self] (completed) in
            self?.selectedIndexDidChange()
            self?.cacheController.scrollingDidFinish()
        }
    }

    // MARK: - DeckLayoutControllerDelegate
    
    internal func deckLayoutDidChange() {
        contentView.frame = CGRectMake(0, 0, layoutController.contentSize.width, layoutController.contentSize.height)
        updateVisibleCardFrames(true)
    }
    
    // MARK: - DeckCacheControllerDelegate
    
    func cacheDidFinishInitialization() {
        for card in cacheController.cachedCards {
            initializeCard(card)
        }
        
        updateVisibleCardFrames(true)
    }
    
    func deferredSelectedCardDidFinishInitialization() {
        initializeCard(cacheController.selectedCard)
        layoutCard(cacheController.selectedCard)
    }
    
    func deferredSiblingCardsDidFinishInitialization() {        
        if let leftCard = cacheController.leftCard {
            initializeCard(leftCard)
            layoutCard(leftCard)
        }

        if let rightCard = cacheController.rightCard {
            initializeCard(rightCard)
            layoutCard(rightCard)
        }
    }
    
    // MARK: - Private
    
    private func initializeCard(card : CardViewController) {
        if !contentView.subviews.contains(card.view) {
            contentView.addSubview(card.view)
        }
        
        if !CGSizeEqualToSize(card.view.frame.size, layoutController.cardSize) {
            card.view.frame = CGRectMake(0, 0, layoutController.cardSize.width, layoutController.cardSize.height)
        }
    }
    
    private func layoutCard(card : CardViewController) {
        let cardOffset = layoutController.offsetForCardAtIndex(card.indexInDataSource, selectedCardIndex: selectedIndex)
        card.view.transform = CGAffineTransformMakeTranslation(cardOffset, 0)
    }
    
}
