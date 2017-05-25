//
//  SearchUserResultViewController.swift
//  Accented
//
//  User search result card
//
//  Created by Tiangong You on 5/21/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class SearchUserResultViewController: CardViewController {
    var streamViewController : UserSearchResultStreamViewController!
    var keyword : String
    
    init(keyword : String) {
        self.keyword = keyword
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PEOPLE"
        
        let stream : UserSearchResultModel = StorageService.sharedInstance.getUserSearchResult(keyword: keyword)
        streamViewController = UserSearchResultStreamViewController(stream)
        addChildViewController(streamViewController)
        self.view.addSubview(streamViewController.view)
        streamViewController.view.frame = self.view.bounds
        streamViewController.didMove(toParentViewController: self)
    }
}
