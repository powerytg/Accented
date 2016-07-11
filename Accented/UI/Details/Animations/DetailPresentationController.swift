//
//  DetailPresentationController.swift
//  Accented
//
//  Created by You, Tiangong on 7/11/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailPresentationController: UIPresentationController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    // MARK: UIPresentationController
    
    override func presentationTransitionWillBegin() {
        
    }
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let duration = self.transitionDuration(transitionContext)
        let animationOptions : UIViewAnimationOptions = .CurveEaseOut
        UIView.animateWithDuration(duration, delay: 0, options: animationOptions, animations: {
            toView.transform = CGAffineTransformIdentity
        }) { (finished) in
            let transitionCompleted = !transitionContext.transitionWasCancelled()
            transitionContext.completeTransition(transitionCompleted)
        }
    }
    
    //MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return self
    }
    
}
