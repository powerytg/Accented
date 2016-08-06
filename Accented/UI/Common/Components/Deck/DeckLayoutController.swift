//
//  DeckLayoutController.swift
//  Accented
//
//  Created by You, Tiangong on 8/5/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

protocol DeckLayoutControllerDelegate : NSObjectProtocol{
    func deckLayoutDidChange()
}


class DeckLayoutController: NSObject {

    // Delegate
    weak var delegate : DeckLayoutControllerDelegate?
    
    // Gap between the selected view and its right sibling
    var gap : CGFloat = 20 {
        didSet {
            recalculateCardFrames()
        }
    }
    
    // Visible width of the right sibling
    var visibleRightChildWidth : CGFloat = 40 {
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
    
    // Cached left visible card frames
    var leftVisibleCardFrames = [CGRect]()
    
    // Cached selected card frame
    var selectedCardFrame : CGRect = CGRectZero
    
    // Cached right visible card frames
    var rightVisibleCardFrames = [CGRect]()
    
    // Cached content size
    private var calculatedContentSize = CGSizeZero
    
    private func recalculateCardFrames() {
        calculatedContentSize = CGSizeZero
        leftVisibleCardFrames.removeAll()
        rightVisibleCardFrames.removeAll()
        
        guard !CGSizeEqualToSize(containerSize, CGSizeZero) else { return }
        
        if let ds = dataSource {
            let w = containerSize.width
            let h = containerSize.height
            let cardWidth = w - gap - visibleRightChildWidth
            
            // Calculate the current card frame as well as its left and right siblings, regardless whether these siblings exist
            let leftVisibleFrame = CGRectMake(0, 0, cardWidth, h)
            leftVisibleCardFrames.append(leftVisibleFrame)
            selectedCardFrame = CGRectMake(leftVisibleFrame.origin.x + cardWidth + gap, 0, cardWidth, h)
            
            let rightSiblingFrame1 = CGRectMake(selectedCardFrame.origin.x + cardWidth + gap , 0, cardWidth, h)
            rightVisibleCardFrames.append(rightSiblingFrame1)
            
            let rightSiblingFrame2 = CGRectMake(rightSiblingFrame1.origin.x + cardWidth + gap, 0, cardWidth, h)
            rightVisibleCardFrames.append(rightSiblingFrame2)
            
            let visibleCardCount = min(3, ds.numberOfCards())

            calculatedContentSize = CGSizeMake(CGFloat(visibleCardCount) * w, h)
        }
        
        delegate?.deckLayoutDidChange()
    }
    
    var contentSize : CGSize {
        return calculatedContentSize
    }
    
}
