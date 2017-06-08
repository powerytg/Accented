//
//  DrawerOpenAnimator.swift
//  Accented
//
//  Created by You, Tiangong on 6/16/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DrawerOpenAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    
    private var animationContext : DrawerAnimationContext
    
    init(animationContext : DrawerAnimationContext) {
        self.animationContext = animationContext
        super.init()
    }
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!        
        let duration = self.transitionDuration(using: transitionContext)
        let animationOptions : UIViewAnimationOptions = (animationContext.interactive ? .curveLinear : .curveEaseOut)
        UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: {
            toView.transform = CGAffineTransform.identity
        }) { (finished) in
            let transitionCompleted = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(transitionCompleted)
        }
    }
    
}
