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
    
    func navigateToDetailPage(context : DetailNavigationContext) {
        let detailVC = DetailGalleryViewController(context: context)
        rootNavigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .Push && toVC is DetailGalleryViewController {
            let galleryViewController = toVC as! DetailGalleryViewController
            return DetailPresentationController(photo : galleryViewController.initialSelectedPhoto, sourceImageView: galleryViewController.sourceImageView, fromViewController: fromVC, toViewController: galleryViewController)
        } else {
            return nil
        }
    }
    
}
