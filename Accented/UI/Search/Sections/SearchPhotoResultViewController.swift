//
//  SearchPhotoResultViewController.swift
//  Accented
//
//  Photo search result card
//
//  Created by Tiangong You on 5/21/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class SearchPhotoResultViewController: CardViewController {

    var streamViewController : PhotoSearchResultStreamViewController!
    var keyword : String?
    var tag : String?
    
    init(keyword : String) {
        self.keyword = keyword
        super.init(nibName: nil, bundle: nil)
    }

    init(tag : String) {
        self.tag = tag
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PHOTOS"
        
        var stream : PhotoSearchStreamModel
        if let keyword = self.keyword {
            stream = StorageService.sharedInstance.getPhotoSearchResult(keyword: keyword)
        } else if let tag = self.tag {
            stream = StorageService.sharedInstance.getPhotoSearchResult(tag: tag)
        } else {
            fatalError("Neither tag nor keyword is specified")
        }
        
        streamViewController = PhotoSearchResultStreamViewController(stream)
        addChildViewController(streamViewController)
        self.view.addSubview(streamViewController.view)
        streamViewController.view.frame = self.view.bounds
        streamViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        streamViewController.didMove(toParentViewController: self)
    }
}
