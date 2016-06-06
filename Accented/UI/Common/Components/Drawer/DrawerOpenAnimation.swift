//
//  DrawerOpenAnimation.swift
//  Accented
//
//  Created by Tiangong You on 6/5/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DrawerOpenAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var drawerViewController : DrawerViewController
    
    init(drawer : DrawerViewController) {
        drawerViewController = drawer
        super.init()
    }
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        container.addSubview(toView)
        
        // Prepare entrance animation
        self.drawerViewController.willPerformOpenAnimation()
        
        let duration = self.transitionDuration(transitionContext)
        UIView.animateWithDuration(duration, delay: 0, options: [], animations: { [weak self] in
            self?.drawerViewController.performanceOpenAnimation()
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
    }

}
