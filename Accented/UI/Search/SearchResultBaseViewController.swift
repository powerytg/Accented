//
//  SearchResultBaseViewController.swift
//  Accented
//
//  Base view controller for search result pages
//
//  Created by Tiangong You on 8/26/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class SearchResultBaseViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchButtonSpacingConstraint: NSLayoutConstraint!
    
    var keyword : String?
    var tag : String?
    
    init(keyword : String) {
        self.keyword = keyword
        super.init(nibName: "SearchResultBaseViewController", bundle: nil)
    }
    
    init(tag : String) {
        self.tag = tag
        super.init(nibName: "SearchResultBaseViewController", bundle: nil)
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonDidTap(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchButtonDidTap(_ sender: AnyObject) {
        NavigationService.sharedInstance.navigateToSearch(from: self)
    }
}
