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
    private var selectedIndex = 0
    
    // Previous selected index
    private var previousSelectedIndex = 0
    
    // Total number of cards
    private var totalCardCount = 0
    
    // Content view
    private var contentView = UIView()
    
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
    
    private func updateVisibleCardFrames() {
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
        default:
            // Ignore
            print("good")
        }
    }
    
    private func panGestureDidChange(gesture : UIPanGestureRecognizer) {
        let tx = gesture.translationInView(gesture.view).x
        contentView.transform = CGAffineTransformMakeTranslation(tx, 0)
    }
    
    private func panGestureDidEnd(gesture : UIPanGestureRecognizer) {
        let velocity = gesture.velocityInView(gesture.view).x
        
        if velocity > 0 {
            // Scroll to right
            if selectedIndex > 0 {
                selectedIndex -= 1
                cacheController.scrollToRight()
                
                // The previous left 
            }
        } else {
            // Scroll to left
            if selectedIndex < totalCardCount - 1 {
                selectedIndex += 1
                cacheController.scrollToLeft()
            }
        }
        
        UIView.animateWithDuration(0.3, delay: 0, options: [.CurveEaseOut], animations: { [weak self] in
            self?.contentView.transform = CGAffineTransformIdentity
            self?.updateVisibleCardFrames()
            }) { [weak self] (completed) in
                self?.dataSource?.selectedIndexDidChange()
        }
    }
    
    // MARK: - DeckLayoutControllerDelegate
    
    internal func deckLayoutDidChange() {
        updateVisibleCardFrames()
        contentView.frame = CGRectMake(0, 0, layoutController.contentSize.width, layoutController.contentSize.height)
    }
    
    // MARK: - DeckCacheControllerDelegate
    
    internal func cardCacheDidChange() {
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
}
