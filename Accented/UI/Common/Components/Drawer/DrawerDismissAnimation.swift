//
//  DrawerDismissAnimation.swift
//  Accented
//
//  Created by Tiangong You on 6/5/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DrawerDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        container.addSubview(toView)
        
        let duration = self.transitionDuration(transitionContext)
        let dest = CGRectGetWidth(container.frame)
        UIView.animateWithDuration(duration, delay: 0, options: [], animations: {
            toView.transform = CGAffineTransformMakeTranslation(dest, 0)
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
    }
}
