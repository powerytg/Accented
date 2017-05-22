//
//  SearchResultViewController.swift
//  Accented
//
//  Created by Tiangong You on 5/21/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController, DeckViewControllerDataSource, DeckViewControllerDelegate, DeckNavigationBarDelegate {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var navView: DeckNavigationBar!
    
    fileprivate var keyword : String?
    fileprivate var tag : String?
    
    // Card deck, by default automatically select photo card (which is at index 0)
    fileprivate let deck = DeckViewController(initialSelectedIndex: 0)
    
    // Cards
    fileprivate var photoCard : SearchPhotoResultViewController!
    fileprivate var userCard : SearchUserResultViewController?
    fileprivate let deckPaddingTop : CGFloat = 170
    
    init(keyword : String) {
        self.keyword = keyword
        super.init(nibName: "SearchResultViewController", bundle: nil)
    }
    
    init(tag : String) {
        self.tag = tag
        super.init(nibName: "SearchResultViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if keyword == nil && tag == nil {
            fatalError("Keyword and tag cannot be both nil")
        }
        
        // Setup title
        titleLabel.preferredMaxLayoutWidth = 120
        if let keyword = self.keyword {
            titleLabel.text = keyword
            photoCard = SearchPhotoResultViewController(keyword: keyword)
            userCard = SearchUserResultViewController()
        } else {
            titleLabel.text = tag!
            photoCard = SearchPhotoResultViewController(tag : tag!)
        }
        
        // Setup cards
        addChildViewController(deck)
        view.addSubview(deck.view)
        deck.view.frame = CGRect(x: 0,
                                 y: deckPaddingTop,
                                 width: view.bounds.size.width,
                                 height: view.bounds.size.height - deckPaddingTop)
        deck.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        deck.didMove(toParentViewController: self)
        deck.dataSource = self
        deck.deckViewDelegate = self
        
        navView.dataSource = self
        navView.delegate = self
    }

    @IBAction func backButtonDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func searchButtonDidTap(_ sender: Any) {
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
