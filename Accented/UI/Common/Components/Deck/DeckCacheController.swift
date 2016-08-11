//
//  DeckCacheController.swift
//  Accented
//
//  Created by You, Tiangong on 8/5/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

protocol DeckCacheControllerDelegate : NSObjectProtocol {
    // Invoked when the on-screen cards has changed
    func cardCacheDidChange()
    
    // Invoked when the sibling cards has been created for the initial selected card
    func initialSiblingCardsDidFinishInitialization()
}

class DeckCacheController: NSObject {

    // Delegate
    weak var delegate : DeckCacheControllerDelegate?
    
    // Recycled view controllers
    private var recycledCards = [CardViewController]()

    // Reference to the data source
    weak var dataSource : DeckViewControllerDataSource?
    
    // Total number of items
    private var totalItemCount = 0
    
    var selectedCardViewController : CardViewController?
    var leftVisibleCardViewControllers = [CardViewController]()
    var rightVisibleCardViewControllers = [CardViewController]()
    var visibleCardViewControllers = [CardViewController]()
    
    // Selected index, initially -1
    private var selectedIndex : Int = -1
    
    func initializeCache(initialSelectedIndex : Int) {
        // Remove all previous cache
        recycledCards.removeAll()
        
        if let ds = dataSource {
            // Pre-populate the cache with cards
            self.totalItemCount = ds.numberOfCards()
            selectedIndex = initialSelectedIndex
            
            // Populate the selected card and its siblings
            let leftSiblingCount = leftVisibleSiblingCount(initialSelectedIndex)
            let rightSiblingCount = rightVisibleSiblingCount(initialSelectedIndex)
            if leftSiblingCount > 0 {
                for index in (initialSelectedIndex - leftSiblingCount)...(initialSelectedIndex - 1) {
                    let card = ds.cardForItemIndex(index)
                    leftVisibleCardViewControllers.append(card)
                }
            }
            
            selectedCardViewController = ds.cardForItemIndex(initialSelectedIndex)

            if rightSiblingCount > 0 {
                for index in (initialSelectedIndex + 1)...(initialSelectedIndex + rightSiblingCount) {
                    let card = ds.cardForItemIndex(index)
                    rightVisibleCardViewControllers.append(card)
                }
            }
        }
        
        updateVisibleCardViewControllers()
        delegate?.cardCacheDidChange()
    }

    func initializeSelectedCard(initialSelectedIndex : Int) {
        // Remove all previous cache
        recycledCards.removeAll()
        
        if let ds = dataSource {
            // Pre-populate the cache with cards
            self.totalItemCount = ds.numberOfCards()
            selectedIndex = initialSelectedIndex
            
            // Populate the selected card and its siblings
            selectedCardViewController = ds.cardForItemIndex(initialSelectedIndex)
            
            updateVisibleCardViewControllers()
            delegate?.cardCacheDidChange()
        }        
    }
    
    func initializeSelectedCardSiblings() {
        let leftSiblingCount = leftVisibleSiblingCount(selectedIndex)
        let rightSiblingCount = rightVisibleSiblingCount(selectedIndex)
        
        if leftSiblingCount > 0 {
            for index in (selectedIndex - leftSiblingCount)...(selectedIndex - 1) {
                let card = dataSource!.cardForItemIndex(index)
                leftVisibleCardViewControllers.append(card)
            }
        }
        
        if rightSiblingCount > 0 {
            for index in (selectedIndex + 1)...(selectedIndex + rightSiblingCount) {
                let card = dataSource!.cardForItemIndex(index)
                rightVisibleCardViewControllers.append(card)
            }
        }
        
        updateVisibleCardViewControllers()
        delegate?.initialSiblingCardsDidFinishInitialization()
    }
    
    // Left visible siblings can be no more than 1 (because the selected card is always aligned to the left edge of screen)
    func leftVisibleSiblingCount(index : Int) -> Int {
        if totalItemCount == 0 || index == 0 {
            return 0
        }
        
        return 1
    }
    
    // Right visible siblings can be no more than 2 (one is visible on screen, the other prepared in case of swiping to right)
    func rightVisibleSiblingCount(index : Int) -> Int {
        if totalItemCount == 0 {
            return 0
        }
        
        if index == totalItemCount - 1 {
            return 0
        }
        
        if index == totalItemCount - 2 {
            return 1
        }
        
        return 2
    }
    
    func scrollToRight() {
        guard dataSource != nil else { return }
        guard totalItemCount > 0 else { return }
        guard selectedIndex > 0 else { return }
        
        selectedIndex -= 1
        let ds = dataSource
        let previousSelectedViewController = selectedCardViewController!
        
        // We can recycle the previous off screen far end right sibling since it'll be two screens away
        if rightVisibleCardViewControllers.count > 1 {
            let recycledRightSibling = rightVisibleCardViewControllers.removeLast()
            recycledRightSibling.view.hidden = true
            recycledCards.append(recycledRightSibling)
        }
        
        // Previous left sibling becomes the new selected view controller
        if leftVisibleCardViewControllers.count > 0 {
            let previousLeftSibling = leftVisibleCardViewControllers.removeLast()
            selectedCardViewController = previousLeftSibling
            selectedCardViewController!.view.hidden = false
        }
        
        // Previous selected vc becomes the first right sibling
        previousSelectedViewController.view.hidden = false
        rightVisibleCardViewControllers.insert(previousSelectedViewController, atIndex: 0)
        
        // Populate the left siblings
        if leftVisibleSiblingCount(selectedIndex) > 0 {
            if let newLeftSibling = ds?.cardForItemIndex(selectedIndex - 1) {
                leftVisibleCardViewControllers.append(newLeftSibling)
                newLeftSibling.view.hidden = true
            }
        }
        
        updateVisibleCardViewControllers()
        delegate?.cardCacheDidChange()
    }

    func scrollToLeft() {
        guard dataSource != nil else { return }
        guard totalItemCount > 0 else { return }
        guard selectedIndex < totalItemCount - 1 else { return }
        
        selectedIndex += 1
        let ds = dataSource
        let previousSelectedViewController = selectedCardViewController!
        
        // We can recycle the previous left sibling since it'll be two screens away
        if leftVisibleCardViewControllers.count > 0 {
            let recycledLeftSibling = leftVisibleCardViewControllers.removeFirst()
            recycledLeftSibling.view.hidden = true
            recycledCards.append(recycledLeftSibling)
        }
        
        // Previous selected vc becomes the new left sibling
        leftVisibleCardViewControllers.append(previousSelectedViewController)
        previousSelectedViewController.view.hidden = false
        
        // Previous right sibling becomes the new selected view controller
        if rightVisibleCardViewControllers.count > 0 {
            let previousRightSibling = rightVisibleCardViewControllers.removeFirst()
            selectedCardViewController = previousRightSibling
            selectedCardViewController!.view.hidden = false
        }
        
        // Populate an off-screen right sibling
        if rightVisibleSiblingCount(selectedIndex) > 1 {
            if let offscreenRightSibling = ds?.cardForItemIndex(selectedIndex + 2) {
                rightVisibleCardViewControllers.append(offscreenRightSibling)
                offscreenRightSibling.view.hidden = true
            }
        }
        
        updateVisibleCardViewControllers()
        delegate?.cardCacheDidChange()
    }

    func getRecycledCardViewController() -> CardViewController? {
        if recycledCards.count == 0 {
            return nil
        } else {
            let card = recycledCards.removeLast()
            card.prepareForReuse()
            return card
        }
    }
    
    private func updateVisibleCardViewControllers() {
        guard dataSource != nil else { return }
        
        visibleCardViewControllers.removeAll()
        visibleCardViewControllers += leftVisibleCardViewControllers
        visibleCardViewControllers.append(selectedCardViewController!)
        visibleCardViewControllers += rightVisibleCardViewControllers
    }
}
