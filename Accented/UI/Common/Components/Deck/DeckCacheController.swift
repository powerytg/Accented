//
//  DeckCacheController.swift
//  Accented
//
//  Created by You, Tiangong on 8/5/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

protocol DeckCacheControllerDelegate : NSObjectProtocol {
    func cardCacheDidChange()
}

class DeckCacheController: NSObject {

    // Delegate
    weak var delegate : DeckCacheControllerDelegate?
    
    // Recycled view controllers
    private var cardCache = [CardViewController]()

    // Reference to the data source
    weak var dataSource : DeckViewControllerDataSource?
    
    // Total number of items
    private var totalItemCount = 0
    
    var selectedCardViewController : CardViewController?
    var leftVisibleCardViewControllers = [CardViewController]()
    var rightVisibleCardViewControllers = [CardViewController]()
    
    func initializeCache(initialSelectedIndex : Int) {
        // Remove all previous cache
        cardCache.removeAll()
        
        if let ds = dataSource {
            // Pre-populate the cache with cards
            self.totalItemCount = ds.numberOfCards()
            
            // Populate the selected card and its siblings
            selectItemAt(initialSelectedIndex)
        }
        
        delegate?.cardCacheDidChange()
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
    
    func selectItemAt(selectedIndex : Int) {
        guard totalItemCount > 0 else { return }
        
        leftVisibleCardViewControllers.removeAll()
        rightVisibleCardViewControllers.removeAll()
        
        if let ds = dataSource {
            // Populate the selected card
            selectedCardViewController = ds.cardForItemIndex(selectedIndex)

            // Populate the left sibling
            if selectedIndex >= 1 {
                leftVisibleCardViewControllers.append(ds.cardForItemIndex(selectedIndex - 1))
            }
            
            // Populate the right sibling
            if selectedIndex < totalItemCount - 1 {
                rightVisibleCardViewControllers.append(ds.cardForItemIndex(selectedIndex + 1))
            }
            
            if selectedIndex < totalItemCount - 2 {
                rightVisibleCardViewControllers.append(ds.cardForItemIndex(selectedIndex + 2))
            }

            cardCache += leftVisibleCardViewControllers
            cardCache.append(selectedCardViewController!)
            cardCache += rightVisibleCardViewControllers
        }
    }

    func getRecycledCardViewController() -> CardViewController? {
        if cardCache.count == 0 {
            return nil
        } else {
            let card = cardCache.removeLast()
            card.prepareForReuse()
            return card
        }
    }
    
}
