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
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let fromView = fromViewController?.view
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!        
        let duration = self.transitionDuration(using: transitionContext)
        let animationOptions : UIViewAnimationOptions = (animationContext.interactive ? .curveLinear : .curveEaseOut)
        UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: {
            if fromView != nil {
                let scale = CGAffineTransform(scaleX: 0.94, y: 0.94)
                var translation : CGAffineTransform
                switch(self.animationContext.anchor) {
                case .bottom:
                    translation = CGAffineTransform(translationX: 0, y: -25)
                case .left:
                    translation = CGAffineTransform(translationX: 25, y: 0)
                case .right:
                    translation = CGAffineTransform(translationX: -25, y: 0)
                }
                
                fromView!.transform = scale.concatenating(translation)
            }
            
            toView.transform = CGAffineTransform.identity
        }) { (finished) in
            let transitionCompleted = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(transitionCompleted)
        }
    }
    
}
