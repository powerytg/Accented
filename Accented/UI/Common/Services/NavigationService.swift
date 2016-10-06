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
    weak fileprivate var rootNavigationController : UINavigationController?
    
    // Singleton instance
    static let sharedInstance = NavigationService()
    
    fileprivate override init() {
        // Do nothing
    }

    func initWithRootNavigationController(_ navigationController : UINavigationController) {
        self.rootNavigationController = navigationController
        rootNavigationController?.delegate = self
    }
    
    func navigateToDetailPage(_ context : DetailNavigationContext) {
        let detailVC = DetailGalleryViewController(context: context)
        rootNavigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push && toVC is DetailGalleryViewController {
            let galleryViewController = toVC as! DetailGalleryViewController
            return DetailPresentationController(photo : galleryViewController.initialSelectedPhoto, sourceImageView: galleryViewController.sourceImageView, fromViewController: fromVC, toViewController: galleryViewController)
        } else {
            return nil
        }
    }
    
    func navigateToCommentsPage(_ photo : PhotoModel) {
        let vc = DetailCommentsViewController()
        vc.photo = photo
        rootNavigationController?.pushViewController(vc, animated: true)
    }
    
}
