//
//  DrawerOpenAnimator.swift
//  Accented
//
//  Created by You, Tiangong on 6/16/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DrawerOpenAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    
    private weak var drawerViewController : DrawerViewController?
    private var interactive : Bool
    
    init(drawer : DrawerViewController, interactive : Bool) {
        self.drawerViewController = drawer
        self.interactive = interactive
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
        self.drawerViewController?.willPerformOpenAnimation()
        
        let duration = self.transitionDuration(transitionContext)
        let animationOptions : UIViewAnimationOptions = (self.interactive ? [.CurveLinear] : [.CurveEaseOut])
        UIView.animateWithDuration(duration, delay: 0, options: animationOptions, animations: { [weak self] in
            self?.drawerViewController?.performanceOpenAnimation()
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
    }
    
}
