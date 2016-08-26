//
//  DeckLayoutController.swift
//  Accented
//
//  Created by You, Tiangong on 8/5/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

/**
 Event delegate
 */
protocol DeckLayoutControllerDelegate : NSObjectProtocol{
    func deckLayoutDidChange()
}

/**
 Simple layout manager to calculate the logical position for cards
 */
class DeckLayoutController: NSObject {

    // Delegate
    weak var delegate : DeckLayoutControllerDelegate?
    
    // Gap between the selected view and its right sibling
    var gap : CGFloat = 10 {
        didSet {
            recalculateCardFrames()
        }
    }
    
    // Visible width of the right sibling
    var visibleRightChildWidth : CGFloat = 10 {
        didSet {
            recalculateCardFrames()
        }
    }
    
    // Reference to the data source
    weak var dataSource : DeckViewControllerDataSource? {
        didSet {
            recalculateCardFrames()
        }
    }
    
    // Containe size
    var containerSize : CGSize = CGSizeZero {
        didSet {
            recalculateCardFrames()
        }
    }
    
    // Base origin is the logical position of the first card in the x axis
    private var baselinePosition : CGFloat = 0
    
    // All cards actually share the same frame with origin of (0 0), their position on screen is manipulated by transforms
    var cardSize = CGSizeZero
    
    // Cached content size
    var contentSize = CGSizeZero
    
    // Page width
    var cardWidth : CGFloat = 0
    
    // Get the position offset for a card at index, based off the selected card index
    // NOTE: selected card is always at the center of screen, meaning that its position will be the baselinePosition
    func offsetForCardAtIndex(index : Int, selectedCardIndex : Int) -> CGFloat {
        return baselinePosition + (cardWidth + gap) * CGFloat(index - selectedCardIndex)
    }
    
    private func recalculateCardFrames() {
        contentSize = CGSizeZero
        cardSize = CGSizeZero
        guard !CGSizeEqualToSize(containerSize, CGSizeZero) else { return }
        guard dataSource != nil else { return }
        
        cardWidth = containerSize.width - gap - visibleRightChildWidth
        cardSize = CGSizeMake(cardWidth, containerSize.height)
        contentSize = CGSizeMake(CGFloat(dataSource!.numberOfCards()) * containerSize.width, containerSize.height)
        delegate?.deckLayoutDidChange()
    }
    
}
