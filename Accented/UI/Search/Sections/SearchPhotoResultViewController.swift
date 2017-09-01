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

class SearchPhotoResultViewController: CardViewController, SearchResultFilterViewControllerDelegate, SheetMenuDelegate {

    var streamViewController : PhotoSearchResultStreamViewController!
    var sortingOptionsViewController : SearchResultFilterViewController!
    var keyword : String?
    var tag : String?
    private var sortingModel = PhotoSearchFilterModel()
    private let sortingBarHeight : CGFloat = 40
    private let streamTopMargin : CGFloat = 44
    
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
        
        let sortingOption = sortingModel.selectedItem as! SortingOptionMenuItem
        var stream : PhotoSearchStreamModel
        if let keyword = self.keyword {
            stream = StorageService.sharedInstance.getPhotoSearchResult(keyword: keyword, sort : sortingOption.option)
        } else if let tag = self.tag {
            stream = StorageService.sharedInstance.getPhotoSearchResult(tag: tag, sort : sortingOption.option)
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
        let bottomSheet = SearchResultSortingBottomSheetViewController(model: sortingModel)
        bottomSheet.delegate = self
        let animationContext = DrawerAnimationContext(content: bottomSheet)
        animationContext.anchor = .bottom
        animationContext.container = topVC
        animationContext.drawerSize = CGSize(width: UIScreen.main.bounds.size.width, height: 266)
        DrawerService.sharedInstance.presentDrawer(animationContext)
    }

    // MARK: - SheetMenuDelegate
    func sheetMenuSelectedOptionDidChange(menuSheet: SheetMenuViewController, selectedIndex: Int) {
        menuSheet.dismiss(animated: true, completion: nil)
        
        if sortingModel.selectedItem == nil || sortingModel.items.index(of: sortingModel.selectedItem!) != selectedIndex {
            let selectedOption = sortingModel.items[selectedIndex] as! SortingOptionMenuItem
            sortingModel.selectedItem = selectedOption
            StorageService.sharedInstance.currentPhotoSearchSortingOption = selectedOption.option
            sortingOptionsViewController.view.setNeedsLayout()
            
            // Notify the steam to update
            streamViewController.sortConditionDidChange(sort : selectedOption.option)
        }
    }
}
