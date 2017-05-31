//
//  PagerViewController.swift
//  Accented
//
//  PagerViewController is a gallery style container controller
//  Unlike DeckViewController which recycles its cards, PagerViewController provides no cache management.
//  All cards must be unique at creation time
//
//  Created by Tiangong You on 5/28/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class PagerViewController: UIViewController {
    
    // Card view controllers
    fileprivate let cards : [CardViewController]

    // Gap between the selected view and its right sibling
    var gap : CGFloat = 10 {
        didSet {
            view.setNeedsLayout()
        }
    }
    
    // Visible width of the right sibling
    var visibleRightChildWidth : CGFloat = 10 {
        didSet {
            view.setNeedsLayout()
        }
    }
    
    // Content view
    var contentView = UIView()

    // Animation configurations
    fileprivate var animationParams = DeckAnimationParams()

    // Pan gesture
    var panGesture : UIPanGestureRecognizer!

    // Selected index
    var selectedIndex = 0

    // Page width
    fileprivate var cardWidth : CGFloat {
        return view.bounds.size.width - gap - visibleRightChildWidth
    }

    // Base origin is the logical position of the first card in the x axis
    fileprivate var baselinePosition : CGFloat = 0

    init(cards : [CardViewController]) {
        self.cards = cards
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialization
        self.automaticallyAdjustsScrollViewInsets = false

        // Create the content container
        contentView.frame = view.bounds
        self.view.addSubview(contentView)
        contentView.clipsToBounds = false
        
        for (index, card) in cards.enumerated() {
            addChildViewController(card)
            contentView.addSubview(card.view)
            let cardOriginX = offsetForCardAtIndex(index)
            card.view.frame = CGRect(x: cardOriginX, y: 0, width: cardWidth, height: view.bounds.size.height)
            card.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            card.didMove(toParentViewController: self)
        }
        
        // Events
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(didReceivePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func invalidateLayout() {
        contentView.frame = view.bounds
        view.setNeedsLayout()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        for (index, card) in cards.enumerated() {
            let cardOriginX = offsetForCardAtIndex(index)
            card.view.frame = CGRect(x: cardOriginX, y: 0, width: cardWidth, height: contentView.bounds.size.height)
            card.view.setNeedsLayout()
        }
    }
    
    // MARK: - Gestures and scrolling
    
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
        let cardOffset = offsetForCardAtIndex(selectedIndex)
        for card in cards {
            card.view.transform = CGAffineTransform(translationX: -cardOffset + tx, y: 0)
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
                scrollToItemAtIndex(index: max(0, selectedIndex - 1))
            } else {
                scrollToItemAtIndex(index: min(cards.count - 1, selectedIndex + 1))
            }
        } else {
            cancelScrolling()
        }
    }
    
    func scrollToItemAtIndex(index : Int) {
        if index < 0 || index > cards.count - 1 {
            return
        }
        
        let targetOffset = -offsetForCardAtIndex(index)
        UIView.animate(withDuration: 0.2, animations: {
            for card in self.cards {
                card.view.transform = CGAffineTransform(translationX: targetOffset, y: 0)
            }
            
        }) { [weak self] (finished) in
            self?.selectedIndex = index;
        }
    }
    
    fileprivate func cancelScrolling() {
        scrollToItemAtIndex(index: selectedIndex)
    }
    
    // Get the position offset for a card at index
    fileprivate func offsetForCardAtIndex(_ index : Int) -> CGFloat {
        return baselinePosition + (cardWidth + gap) * CGFloat(index)
    }
}
