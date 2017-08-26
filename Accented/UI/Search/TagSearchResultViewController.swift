//
//  TagSearchResultViewController.swift
//  Accented
//
//  Search result page for tag search
//
//  Created by You, Tiangong on 8/26/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class TagSearchResultViewController: SearchResultBaseViewController {
    
    private var streamViewController : TagSearchStreamViewController!
    private var sortingModel = PhotoSearchFilterModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = nil
        searchButtonSpacingConstraint.constant = 0
        
        let stream : PhotoSearchStreamModel = StorageService.sharedInstance.getPhotoSearchResult(tag: tag!, sort : sortingModel.selectedOption)        
        streamViewController = TagSearchStreamViewController(stream)
        addChildViewController(streamViewController)
        self.view.insertSubview(streamViewController.view, at: 1)
        streamViewController.didMove(toParentViewController: self)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        streamViewController.view.frame = view.bounds
    }
}
