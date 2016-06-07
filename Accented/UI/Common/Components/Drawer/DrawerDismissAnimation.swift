//
//  DrawerDismissAnimation.swift
//  Accented
//
//  Created by Tiangong You on 6/5/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DrawerDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var drawerViewController : DrawerViewController
    
    init(drawer : DrawerViewController) {
        drawerViewController = drawer
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
        self.drawerViewController.willPerformDismissAnimation()
        
        let duration = self.transitionDuration(transitionContext)
        UIView.animateWithDuration(duration, delay: 0, options: [.CurveEaseOut], animations: { [weak self] in
            self?.drawerViewController.performanceDismissAnimation()
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
    }
}
