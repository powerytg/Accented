//
//  DeckCacheController.swift
//  Accented
//
//  Created by You, Tiangong on 8/5/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

protocol DeckCacheControllerDelegate : NSObjectProtocol {
    // Invoked when the cache has finished initialization (for non-deferred configuration)
    func cacheDidFinishInitialization()
    
    // Invoked when the initial selected card has finished initialization (for deferred configuration)
    func deferredSelectedCardDidFinishInitialization()

    // Invoked when the initial sibling cards hav finished initialization (for deferred configuration)
    func deferredSiblingCardsDidFinishInitialization()
    
    // Invoked when a card has been added to cache
    func cardDidAddToCache(card : CardViewController)
}

class DeckCacheController: NSObject {

    // Delegate
    weak var delegate : DeckCacheControllerDelegate?
    
    // Reference to the data source
    weak var dataSource : DeckViewControllerDataSource?
    
    // Total number of items
    private var totalItemCount = 0
    
    // Currently selected card
    var selectedCard : CardViewController!
    
    // Left sibling
    var leftCard : CardViewController?
    
    // Right sibling
    var rightCard : CardViewController?
    
    // Off-screen view controller for heat-up purpose
    var offScreenCard : CardViewController?

    // Recucled card
    var recycledCard : CardViewController?

    // All cards, including those on-screen and those already recycled
    var cachedCards = [CardViewController]()
    
    // Selected index, initially -1
    private var selectedIndex : Int = -1
    
    func initializeCache(initialSelectedIndex : Int) {
        guard dataSource != nil else { return }
        let ds = dataSource!
        
        // Pre-populate the cache with cards
        totalItemCount = ds.numberOfCards()
        selectedIndex = initialSelectedIndex
        
        // Populate the selected, left, right and off-screen siblings
        selectedCard = getCardFromDataSource(initialSelectedIndex)
        selectedCard.withinVisibleRange = true
        
        if hasLeftSibling(selectedIndex) {
            leftCard = getCardFromDataSource(selectedIndex - 1)
            leftCard!.withinVisibleRange = true
        }
        
        if hasRightSibling(selectedIndex) {
            rightCard = getCardFromDataSource(selectedIndex + 1)
            rightCard!.withinVisibleRange = true
        }
        
        if hasOffScreenRightSibling(selectedIndex) {
            offScreenCard = getCardFromDataSource(selectedIndex + 2)
            offScreenCard!.withinVisibleRange = false
        }
        
        delegate?.cacheDidFinishInitialization()
    }

    func initializeSelectedCard(initialSelectedIndex : Int) {
        guard dataSource != nil else { return }
        let ds = dataSource!
        totalItemCount = ds.numberOfCards()
        selectedIndex = initialSelectedIndex

        // Populate the selected card
        selectedCard = getCardFromDataSource(initialSelectedIndex)
        selectedCard.withinVisibleRange = true
        delegate?.deferredSelectedCardDidFinishInitialization()
    }
    
    func initializeSelectedCardSiblings() {
        if hasLeftSibling(selectedIndex) {
            leftCard = getCardFromDataSource(selectedIndex - 1)
            leftCard!.withinVisibleRange = true
        }
        
        if hasRightSibling(selectedIndex) {
            rightCard = getCardFromDataSource(selectedIndex + 1)
            rightCard!.withinVisibleRange = true
        }
        
        if hasOffScreenRightSibling(selectedIndex) {
            offScreenCard = getCardFromDataSource(selectedIndex + 2)
            offScreenCard!.withinVisibleRange = false
        }

        delegate?.deferredSiblingCardsDidFinishInitialization()
    }
    
    func hasLeftSibling(index : Int) -> Bool {
        return (totalItemCount != 0 && index != 0)
    }

    func hasRightSibling(index : Int) -> Bool {
        return (totalItemCount != 0 && index != totalItemCount - 1)
    }
    
    func hasOffScreenRightSibling(index : Int) -> Bool {
        return (totalItemCount != 0 && index < totalItemCount - 2)
    }

    func hasOffScreenLeftSibling(index : Int) -> Bool {
        return (totalItemCount != 0 && index > 1)
    }

    func scrollToRight() {
        guard dataSource != nil else { return }
        guard totalItemCount > 0 else { return }
        guard selectedIndex > 0 else { return }
        
        let previousSelectedViewController = selectedCard
        let targetSelectedIndex = selectedIndex - 1
        
        // We can recycle the previous off-screen sibling since it'll be two screens away
        if offScreenCard != nil {
            recycleCard(offScreenCard!)
            offScreenCard = nil
        }
        
        // Previous left sibling becomes the new selected view controller
        if leftCard != nil {
            selectedCard = leftCard
            selectedCard.withinVisibleRange = true
        }

        // Previous right card becomes the new right off-screen sibling
        offScreenCard = rightCard
        offScreenCard?.withinVisibleRange = false
        
        // Previous selected card becomes the right card
        rightCard = previousSelectedViewController
        rightCard!.withinVisibleRange = true
        
        // Update selected index
        selectedIndex = targetSelectedIndex
    }

    func scrollToLeft() {
        guard dataSource != nil else { return }
        guard totalItemCount > 0 else { return }
        guard selectedIndex < totalItemCount - 1 else { return }
        
        let previousSelectedViewController = selectedCard
        let targetSelectedIndex = selectedIndex + 1
        
        // We can recycle the previous left sibling since it'll be two screens away
        if leftCard != nil {
            recycleCard(leftCard!)
        }
        
        // Previous selected vc becomes the new left sibling
        if hasLeftSibling(targetSelectedIndex) {
            leftCard = previousSelectedViewController
            leftCard!.withinVisibleRange = true
        } else {
            leftCard = nil
        }
        
        // Previous right sibling becomes the new selected view controller
        if rightCard != nil {
            selectedCard = rightCard
            selectedCard.withinVisibleRange = true
        }
        
        // Previous right off-screen sibling becomes the new right sibling
        if hasRightSibling(targetSelectedIndex) {
            rightCard = offScreenCard
            rightCard?.withinVisibleRange = true
        } else {
            rightCard = nil
        }
        
        // Update selected index
        selectedIndex = targetSelectedIndex
    }

    func populateRightOffScreenSibling() {
        // Prepare for off-screen cards
        if hasOffScreenRightSibling(selectedIndex) {
            offScreenCard = getCardFromDataSource(selectedIndex + 2)
            offScreenCard?.withinVisibleRange = false
        } else {
            offScreenCard = nil
        }
    }

    func populateLeftOffScreenSibling() {
        // Prepare for off-screen cards
        if hasLeftSibling(selectedIndex) {
            leftCard = getCardFromDataSource(selectedIndex - 1)
            leftCard?.withinVisibleRange = true
        } else {
            leftCard = nil
        }
    }

    func getRecycledCardViewController() -> CardViewController? {
        if recycledCard != nil {
            recycledCard!.withinVisibleRange = true
        }
        return recycledCard
    }
    
    private func getCardFromDataSource(index : Int) -> CardViewController {
        let card = dataSource!.cardForItemIndex(index)
        card.indexInDataSource = index
        
        if !cachedCards.contains(card) {
            cachedCards.append(card)
            delegate?.cardDidAddToCache(card)
        }
        
        return card
    }
    
    private func recycleCard(card : CardViewController) {
        card.prepareForReuse()
        recycledCard = card
    }
}
