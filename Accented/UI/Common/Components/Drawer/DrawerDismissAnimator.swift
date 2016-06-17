//
//  DrawerDismissAnimator.swift
//  Accented
//
//  Created by You, Tiangong on 6/16/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DrawerDismissAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    
    private var animationContext : DrawerAnimationContext
    
    init(animationContext : DrawerAnimationContext) {
        self.animationContext = animationContext
        super.init()
    }
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.2
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()!
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        
        container.addSubview(fromView)
        
        // Prepare entrance animation
        animationContext.drawer?.willPerformDismissAnimation()
        
        let duration = self.transitionDuration(transitionContext)
        let animationOptions : UIViewAnimationOptions = (animationContext.interactive ? [.CurveLinear] : [.CurveEaseOut])
        UIView.animateWithDuration(duration, delay: 0, options: animationOptions, animations: { [weak self] in
            self?.animationContext.drawer?.performanceDismissAnimation()
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
    }
}
