//
//  NavigationService.swift
//  Accented
//
//  Created by You, Tiangong on 7/11/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class NavigationService: NSObject {

    // root navigation controller
    weak private var rootNavigationController : UINavigationController?
    
    // Singleton instance
    static let sharedInstance = NavigationService()
    private override init() {
        // Do nothing
    }

    func initWithRootNavigationController(navigationController : UINavigationController) {
        self.rootNavigationController = navigationController
    }
    
    func navigateToDetailPage() {
        let detailPage = DetailViewController()
        rootNavigationController?.pushViewController(detailPage, animated: true)
    }
}
