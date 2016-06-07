//
//  DrawerAnimationController.swift
//  Accented
//
//  Created by Tiangong You on 6/5/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DrawerAnimationController: NSObject, UIViewControllerTransitioningDelegate {
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DrawerOpenAnimation(drawer: presented as! DrawerViewController)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DrawerDismissAnimation(drawer : dismissed as! DrawerViewController)
    }
    
//    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return DrawerOpenAnimation(drawer: presented as! DrawerViewController)
//    }
//    
//    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return DrawerDismissAnimation(drawer : dismissed as! DrawerViewController)
//    }
}
