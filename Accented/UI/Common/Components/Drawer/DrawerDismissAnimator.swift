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
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let duration = self.transitionDuration(using: transitionContext)
        let animationOptions : UIViewAnimationOptions = (animationContext.interactive ? [.curveLinear] : [.curveEaseOut])
        UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: { [weak self] in
            self?.performDismissalAnimation(toView?.view)
        }) { (finished) in
            let transitionCompleted = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(transitionCompleted)
        }
    }
    
    private func performDismissalAnimation(_ toView : UIView?) {
        let drawer = animationContext.content.view
        switch animationContext.anchor {
        case .left:
            drawer?.transform = CGAffineTransform(translationX: -(drawer?.bounds.width)!, y: 0)
        case .right:
            drawer?.transform = CGAffineTransform(translationX: (drawer?.bounds.width)!, y: 0)
        case .bottom:
            drawer?.transform = CGAffineTransform(translationX: 0, y: (drawer?.bounds.height)!)
        }
        
        toView?.transform = CGAffineTransform.identity
    }
}
