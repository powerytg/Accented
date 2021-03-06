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

class TagSearchResultViewController: SearchResultBaseViewController, MenuDelegate {
    
    let displayStyleOptions = [MenuItem(action: .ViewAsGroup, text: "View As Groups"),
                               MenuItem(action: .ViewAsList, text: "View As List")]

    let menuOptions = [MenuItem(action: .Home, text: "Home"),
                               MenuItem(action: .ViewAsGroup, text: "View As Groups"),
                               MenuItem(action: .ViewAsList, text: "View As List")]

    private var menuBar : CompactMenuBar!
    private var streamViewController : TagSearchStreamViewController!
    private var sortingModel = PhotoSearchFilterModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = nil
        searchButtonSpacingConstraint.constant = 0
        
        createStreamViewController(.group)
        
        menuBar = CompactMenuBar(menuOptions)
        menuBar.delegate = self
        view.addSubview(menuBar)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didRequestChangeDisplayStyle(_:)), name: StreamEvents.didRequestChangeDisplayStyle, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didRequestChangeSortingOption(_:)), name: StreamEvents.didRequestChangeSortingOptions, object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let streamController = streamViewController {
            var f = streamController.view.frame
            f.size.width = view.bounds.width
            f.size.height = view.bounds.height - CompactMenuBar.defaultHeight
            streamController.view.frame = f
        }
        
        var f = menuBar.frame
        f.size.width = view.bounds.width
        f.size.height = CompactMenuBar.defaultHeight
        f.origin.y = view.bounds.height - f.size.height
        menuBar.frame = f

    }
    
    private func createStreamViewController(_ style : StreamDisplayStyle) {
        let sortingOption = sortingModel.selectedItem as! SortingOptionMenuItem
        let stream : PhotoSearchStreamModel = StorageService.sharedInstance.getPhotoSearchResult(tag: tag!, sort : sortingOption.option)
        streamViewController = TagSearchStreamViewController(stream, displayStyle : style)
        addChildViewController(streamViewController)
        self.view.insertSubview(streamViewController.view, at: 1)
        streamViewController.didMove(toParentViewController: self)
    }

    // MARK : - Events
    @objc private func didRequestChangeDisplayStyle(_ notification : Notification) {
        let menuSheet = MenuViewController(displayStyleOptions)
        menuSheet.delegate = self
        menuSheet.title = "DISPLAY STYLE"
        menuSheet.show()
    }
    
    @objc private func didRequestChangeSortingOption(_ notification : Notification) {
        let menuSheet = MenuViewController(sortingModel.items)
        menuSheet.delegate = self
        menuSheet.title = "SORTING OPTIONS"
        menuSheet.show()
    }
    
    // MARK : - MenuDelegate
    
    func didSelectMenuItem(_ menuItem: MenuItem) {
        if menuItem is SortingOptionMenuItem {
            // Sorting options
            let option = (menuItem as! SortingOptionMenuItem).option
            if menuItem != sortingModel.selectedItem {
                sortingModel.selectedItem = menuItem
                StorageService.sharedInstance.currentPhotoSearchSortingOption = option
                
                // Notify the steam to update
                streamViewController.sortConditionDidChange(sort : option)
            }
        } else {
            var selectedDisplayStyle = streamViewController.displayStyle
            switch menuItem.action {
            case .Home:
                NavigationService.sharedInstance.popToRootController(animated: true)
                return
            case .ViewAsGroup:
                selectedDisplayStyle = .group
            case .ViewAsList:
                selectedDisplayStyle = .card
            default:
                break
            }
            
            if selectedDisplayStyle == streamViewController.displayStyle {
                return
            }
            
            // Remove the previous stream view controller
            streamViewController.willMove(toParentViewController: nil)
            streamViewController.view.removeFromSuperview()
            streamViewController.removeFromParentViewController()
            
            // Create a new stream view controller
            createStreamViewController(selectedDisplayStyle)
        }
    }
}

private class TagSearchMenuOptions : MenuItem { }

