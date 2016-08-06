//
//  DeckViewController.swift
//  Accented
//
//  Created by You, Tiangong on 8/5/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DeckViewController: UIViewController, UIScrollViewDelegate, DeckLayoutControllerDelegate, DeckCacheControllerDelegate {

    // Reference to the data source
    weak var dataSource : DeckViewControllerDataSource? {
        didSet {
            // Remove all previous cards
            removeAllCards()
            
            cacheController.dataSource = dataSource
            layoutController.dataSource = dataSource
            
            // Re-create cache and layout
            if let ds = dataSource {
                selectedIndex = 0
                totalCardCount = ds.numberOfCards()
                cacheController.initializeCache(selectedIndex)
                contentView.frame = CGRectMake(0, 0, layoutController.contentSize.width, layoutController.contentSize.height)
                scrollView.contentSize = layoutController.contentSize
                
                // Automatically select at index 0
                selectItemAt(0)
            }
        }
    }
    
    // Cache controller
    private var cacheController : DeckCacheController
    
    // Layout controller
    private var layoutController : DeckLayoutController
    
    // Selected index
    private var selectedIndex = 0
    
    // Total number of cards
    private var totalCardCount = 0
    
    // Scroll view
    private var scrollView = UIScrollView()
    
    // Content view. This is the view that contains all the cards
    private var contentView = UIView()
    
    init() {
        self.cacheController = DeckCacheController()
        self.layoutController = DeckLayoutController()
        super.init(nibName: nil, bundle: nil)
        
        // Initialization
        self.automaticallyAdjustsScrollViewInsets = false
        self.layoutController.delegate = self
        self.cacheController.delegate = self
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(self.contentView)
        
        // Update container size for the layout controller
        layoutController.containerSize = self.view.bounds.size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.scrollView.frame = self.view.bounds
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
    
    func selectItemAt(index : Int) {
        selectedIndex = index
        cacheController.selectItemAt(index)
        
        updateVisibleCardFrames()
        scrollToSelectedCard()
    }
    
    private func scrollToSelectedCard() {
        scrollView.contentOffset = CGPointMake(layoutController.selectedCardFrame.origin.x, 0)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let currentOffset = scrollView.contentOffset.x
        let targetOffset = targetContentOffset.memory.x
        
        // Calculate the target content offset to allow the scroll view to "snap" to the desire page
        var targetItemIndex = selectedIndex
        var targetFrame = layoutController.selectedCardFrame
        if targetOffset > currentOffset {
            if targetItemIndex + 1 < self.totalCardCount {
                targetItemIndex += 1
                targetFrame = layoutController.rightVisibleCardFrames[0]
            }
        } else {
            if targetItemIndex - 1 >= 0 {
                targetItemIndex -= 1
                targetFrame = layoutController.leftVisibleCardFrames[0]
            }
        }
        
        // Update the selected index
        self.selectedIndex = targetItemIndex
        
        targetContentOffset.memory.x = currentOffset
        scrollView.setContentOffset(CGPointMake(targetFrame.origin.x, 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        cacheController.selectItemAt(selectedIndex)
        updateVisibleCardFrames()
    }
    
    // MARK: - DeckLayoutControllerDelegate
    
    internal func deckLayoutDidChange() {
        updateVisibleCardFrames()
    }
    
    // MARK: - DeckCacheControllerDelegate
    
    internal func cardCacheDidChange() {
        removeAllCards()
        
        for card in cacheController.leftVisibleCardViewControllers {
            contentView.addSubview(card.view)
        }
        
        if let selectedCard = cacheController.selectedCardViewController {
            contentView.addSubview(selectedCard.view)
        }
        
        for card in cacheController.rightVisibleCardViewControllers {
            contentView.addSubview(card.view)
        }
    }
}
