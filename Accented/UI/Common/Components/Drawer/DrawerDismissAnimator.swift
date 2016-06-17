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
        let duration = self.transitionDuration(transitionContext)
        let animationOptions : UIViewAnimationOptions = (animationContext.interactive ? [.CurveLinear] : [.CurveEaseOut])
        UIView.animateWithDuration(duration, delay: 0, options: animationOptions, animations: { [weak self] in
            self?.performDismissalAnimation()
        }) { (finished) in
            let transitionCompleted = !transitionContext.transitionWasCancelled()
            transitionContext.completeTransition(transitionCompleted)
        }
    }
    
    private func performDismissalAnimation() {
        let drawer = animationContext.content.view
        switch animationContext.anchor {
        case .Left:
            drawer.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(drawer.bounds), 0)
        case .Right:
            drawer.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(drawer.bounds), 0)
        case .Bottom:
            drawer.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(drawer.bounds))
        }
    }
}
