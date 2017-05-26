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

class SearchPhotoResultViewController: CardViewController, SearchResultFilterViewControllerDelegate, SearchResultSortingBottomSheetViewControllerDelegate {

    var streamViewController : PhotoSearchResultStreamViewController!
    var sortingOptionsViewController : SearchResultFilterViewController!
    var keyword : String?
    var tag : String?
    fileprivate var sortingModel = PhotoSearchFilterModel()
    fileprivate let sortingBarHeight : CGFloat = 40
    fileprivate let streamTopMargin : CGFloat = 44
    
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
        
        // Initialize sorting options
        sortingOptionsViewController = SearchResultFilterViewController(sortingModel: sortingModel)
        sortingOptionsViewController.delegate = self
        addChildViewController(sortingOptionsViewController)
        self.view.addSubview(sortingOptionsViewController.view)
        sortingOptionsViewController.view.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: sortingBarHeight)
        sortingOptionsViewController.didMove(toParentViewController: self)
        
        // Initialize stream
        streamViewController = PhotoSearchResultStreamViewController(stream)
        addChildViewController(streamViewController)
        self.view.addSubview(streamViewController.view)
        streamViewController.view.frame = CGRect(x: 0, y: streamTopMargin, width: view.bounds.size.width, height: view.bounds.size.height - streamTopMargin)
        streamViewController.didMove(toParentViewController: self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        sortingOptionsViewController.view.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: sortingBarHeight)
    }
    
    // MARK: - SearchResultFilterViewControllerDelegate
    func sortingButtonDidTap() {
        guard let topVC = NavigationService.sharedInstance.topViewController() else { return }
        let bottomSheet = SearchResultSortingBottomSheetViewController(sortingModel : sortingModel)
        bottomSheet.delegate = self
        let animationContext = DrawerAnimationContext(content: bottomSheet)
        animationContext.anchor = .bottom
        animationContext.container = topVC
        animationContext.drawerSize = CGSize(width: UIScreen.main.bounds.size.width, height: 266)
        DrawerService.sharedInstance.presentDrawer(animationContext)
    }

    // MARK: - SearchResultSortingBottomSheetViewControllerDelegate
    func sortingOptionDidChange(bottomSheet: SearchResultSortingBottomSheetViewController, option: PhotoSearchSortingOptions) {
        bottomSheet.dismiss(animated: true, completion: nil)
        
        if option != sortingModel.selectedOption {
            sortingModel.selectedOption = option
            StorageService.sharedInstance.currentPhotoSearchSortingOption = option
            sortingOptionsViewController.view.setNeedsLayout()
        }
    }
}
