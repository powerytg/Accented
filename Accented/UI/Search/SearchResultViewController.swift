//
//  SearchResultViewController.swift
//  Accented
//
//  Created by Tiangong You on 5/21/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class SearchResultViewController: SearchResultBaseViewController, DeckViewControllerDataSource, DeckViewControllerDelegate, DeckNavigationBarDelegate {

    private var navView: DeckNavigationBar!
    
    // Card deck, by default automatically select photo card (which is at index 0)
    private let deck = DeckViewController(initialSelectedIndex: 0)
    
    // Cards
    private var photoCard : SearchPhotoResultViewController!
    private var userCard : SearchUserResultViewController?
    private let deckPaddingTop : CGFloat = 170
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = keyword!
        photoCard = SearchPhotoResultViewController(keyword: keyword!)
        userCard = SearchUserResultViewController(keyword: keyword!)
        
        // Setup cards if we have both results from photos and users
        let w = UIScreen.main.bounds.height
        let h = UIScreen.main.bounds.height
        let navFrame = CGRect(x: 16, y: deckPaddingTop, width: w - 16, height: 40)
        navView = DeckNavigationBar(frame: navFrame)
        deck.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(navView)
        
        
        addChildViewController(deck)
        view.addSubview(deck.view)
        deck.view.frame = CGRect(x: 0,
                                 y: deckPaddingTop,
                                 width: view.bounds.size.width,
                                 height: h - deckPaddingTop)
        deck.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        deck.didMove(toParentViewController: self)
        deck.dataSource = self
        deck.deckViewDelegate = self
        deck.invalidateLayout()
        
        navView.dataSource = self
        navView.delegate = self
    }

    
    private func setupPhotoResultType() {
        navView.isHidden = true
        
        let screenHeight = UIScreen.main.bounds.height
        let photoStreamViewController = SearchPhotoResultViewController(tag: tag!)
        addChildViewController(photoStreamViewController)
        self.view.addSubview(photoStreamViewController.view)
        photoStreamViewController.view.frame = CGRect(x: 0,
                                                      y: deckPaddingTop,
                                                      width: view.bounds.size.width,
                                                      height: screenHeight - deckPaddingTop)
        photoStreamViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        photoStreamViewController.didMove(toParentViewController: self)
    }
    
    // MARK: - DeckViewControllerDelegaate
    
    func deckViewControllerSelectedIndexDidChange() {
        navView.selectedIndex = deck.selectedIndex
    }
    
    // MARK: - DeckNavigationBarDelegate
    func navButtonSelectedIndexDidChange(fromIndex: Int, toIndex: Int) {
        if fromIndex < toIndex {
            deck.scrollToLeft(true)
        } else {
            deck.scrollToRight(true)
        }
    }
    
    // MARK: - DeckViewControllerDataSource
    func numberOfCards() -> Int {
        if keyword == nil {
            // We cannot search users by tag, so there'll be only one result
            return 1
        } else {
            return 2
        }
    }
    
    func cardForItemIndex(_ itemIndex: Int) -> CardViewController {
        if itemIndex == 0 {
            return photoCard
        } else {
            return userCard!
        }
    }
}
