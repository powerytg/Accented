//
//  NavigationService.swift
//  Accented
//
//  Created by You, Tiangong on 7/11/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class NavigationService: NSObject, UINavigationControllerDelegate {

    // root navigation controller
    weak private var rootNavigationController : UINavigationController?
    
    // Singleton instance
    static let sharedInstance = NavigationService()
    private override init() {
        // Do nothing
    }

    func initWithRootNavigationController(navigationController : UINavigationController) {
        self.rootNavigationController = navigationController
        rootNavigationController?.delegate = self
    }
    
    func navigateToDetailPage(photo : PhotoModel, sourceView : UIImageView) {
        let detailViewController = DetailViewController(photo: photo, sourceImageView: sourceView)
        detailViewController.photo = photo
        detailViewController.sourceImageView = sourceView
        rootNavigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .Push && toVC is DetailViewController {
            let detailViewController = toVC as! DetailViewController
            return DetailPresentationController(photo : detailViewController.photo, sourceImageView: detailViewController.sourceImageView, fromViewController: fromVC, toViewController: detailViewController)
        } else {
            return nil
        }
    }
    
}
