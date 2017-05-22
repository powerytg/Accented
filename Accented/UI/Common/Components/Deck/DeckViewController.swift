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
    case `default`
    
    // Only the selected card will be initialized
    case deferred
}

private enum ScrollDirection {
    case left
    case right
}

// Event delegate
protocol DeckViewControllerDelegate : NSObjectProtocol {
    // Invoked when card selection has changed
    func deckViewControllerSelectedIndexDidChange()
}

class DeckViewController: UIViewController, DeckLayoutControllerDelegate, DeckCacheControllerDelegate {

    // Cache initialization policy
    var cacheInitializationPolicy : DeckViewControllerCacheInitializationPolicy = .default
    
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
                
                if cacheInitializationPolicy == .default {
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
    fileprivate var previousSelectedIndex = 0
    
    // Total number of cards
    fileprivate var totalCardCount = 0
    
    // Content view
    var contentView = UIView()
    
    // Animation configurations
    fileprivate var animationParams = DeckAnimationParams()
    
    // Pan gesture
    var panGesture : UIPanGestureRecognizer!
    
    // Delegate
    weak var deckViewDelegate : DeckViewControllerDelegate?
    
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
    
    fileprivate func removeAllCards() {
        for card in self.contentView.subviews {
            card.removeFromSuperview()
        }
    }
    
    // Invoked when the selected index has changed
    func selectedIndexDidChange() {
        for card in cacheController.cachedCards {
            card.cardSelectionDidChange(card.indexInDataSource == selectedIndex)
        }
        
        deckViewDelegate?.deckViewControllerSelectedIndexDidChange()
    }
    
    // Update the frames for the selected view controller as well its siblings
    func updateVisibleCardFrames(_ updateOffScreenCards : Bool) {
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
    func didReceivePanGesture(_ gesture : UIPanGestureRecognizer) {
        switch gesture.state {
        case .ended:
            panGestureDidEnd(gesture)
        case .changed:
            panGestureDidChange(gesture)
        case .cancelled:
            cancelScrolling()
        default: break
        }
    }
    
    fileprivate func panGestureDidChange(_ gesture : UIPanGestureRecognizer) {
        let tx = gesture.translation(in: gesture.view).x
        for card in cacheController.cachedCards {
            if card.withinVisibleRange {
                let cardOffset = layoutController.offsetForCardAtIndex(card.indexInDataSource, selectedCardIndex: selectedIndex)
                card.view.transform = CGAffineTransform(translationX: cardOffset + tx, y: 0)
            }
        }
    }
    
    fileprivate func panGestureDidEnd(_ gesture : UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: gesture.view).x
        let tx = gesture.translation(in: gesture.view).x
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
    func scrollToLeft(_ animated : Bool) {
        // Scroll to left
        if selectedIndex < totalCardCount - 1 {
            selectedIndex += 1
            cacheController.scrollToLeft()
        }

        if animated {
            performScrollingAnimation(.left)
        } else {
            cacheController.populateRightOffScreenSibling()
            self.updateVisibleCardFrames(true)
            self.selectedIndexDidChange()
        }
    }
    
    // Scroll to the previous item
    func scrollToRight(_ animated : Bool) {
        // Scroll to right
        if selectedIndex > 0 {
            selectedIndex -= 1
            cacheController.scrollToRight()
        }
        
        if animated {
            performScrollingAnimation(.right)
        } else {
            cacheController.populateLeftOffScreenSibling()
            self.updateVisibleCardFrames(true)
            self.selectedIndexDidChange()
        }
    }
    
    // Cancel the scrolling and reset to the current position
    fileprivate func cancelScrolling() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
            self?.updateVisibleCardFrames(false)
            }, completion: nil)
    }
    
    // Scroll to the selected view controller
    fileprivate func performScrollingAnimation(_ direction : ScrollDirection) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
            self?.updateVisibleCardFrames(false)
            
        }) { [weak self] (completed) in
            if direction == .left {
                self?.cacheController.populateRightOffScreenSibling()
                self?.layoutCard(self?.cacheController.offScreenCard)
            } else {
                self?.cacheController.populateLeftOffScreenSibling()
                self?.layoutCard(self?.cacheController.leftCard)
            }
            self?.selectedIndexDidChange()
        }
    }

    // MARK: - DeckLayoutControllerDelegate
    
    internal func deckLayoutDidChange() {
        contentView.frame = CGRect(x: 0, y: 0, width: layoutController.containerSize.width, height: layoutController.contentSize.height)
        updateVisibleCardFrames(true)
    }
    
    // MARK: - DeckCacheControllerDelegate
    
    func cacheDidFinishInitialization() {
        updateVisibleCardFrames(true)
    }
    
    func deferredSelectedCardDidFinishInitialization() {
        layoutCard(cacheController.selectedCard)
    }
    
    func deferredSiblingCardsDidFinishInitialization() {        
        if let leftCard = cacheController.leftCard {
            layoutCard(leftCard)
        }

        if let rightCard = cacheController.rightCard {
            layoutCard(rightCard)
        }
        
        if let offscreenCard = cacheController.offScreenCard {
            layoutCard(offscreenCard)
        }
    }
    
    func cardDidAddToCache(_ card: CardViewController) {
        initializeCard(card)
    }
    
    func selectCardAt(_ index : Int) {
        selectedIndex = index
        
    }
    
    // MARK: - Private
    
    fileprivate func initializeCard(_ card : CardViewController) {
        if !contentView.subviews.contains(card.view) {
            contentView.addSubview(card.view)
        }
        
        if !card.view.frame.size.equalTo(layoutController.cardSize) {
            card.view.frame = CGRect(x: 0, y: 0, width: layoutController.cardSize.width, height: layoutController.cardSize.height)
        }
    }
    
    fileprivate func layoutCard(_ card : CardViewController?) {
        guard card != nil else { return }
        let cardOffset = layoutController.offsetForCardAtIndex(card!.indexInDataSource, selectedCardIndex: selectedIndex)
        card!.view.transform = CGAffineTransform(translationX: cardOffset, y: 0)
    }
    
}
