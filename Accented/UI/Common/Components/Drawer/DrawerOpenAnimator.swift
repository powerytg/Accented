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
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.2
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        container.addSubview(toView)
        
        // Prepare entrance animation
        animationContext.drawer?.willPerformOpenAnimation()
        
        let duration = self.transitionDuration(transitionContext)
        let animationOptions : UIViewAnimationOptions = (animationContext.interactive ? .CurveLinear : .CurveEaseOut)
        UIView.animateWithDuration(duration, delay: 0, options: animationOptions, animations: { [weak self] in
            self?.animationContext.drawer?.performanceOpenAnimation()
        }) { (finished) in            
            transitionContext.completeTransition(true)
        }
    }
    
}
