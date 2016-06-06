//
//  DrawerAnimationController.swift
//  Accented
//
//  Created by Tiangong You on 6/5/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DrawerAnimationController: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        container.addSubview(toView)
        
        // Move the drawer off screen
        let containerWidth = CGRectGetWidth(container.frame)
        toView.transform = CGAffineTransformMakeTranslation(containerWidth, 0)
        
        let duration = self.transitionDuration(transitionContext)
        UIView.animateWithDuration(duration, delay: 0, options: [], animations: {
            toView.transform = CGAffineTransformIdentity
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
