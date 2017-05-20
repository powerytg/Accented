//
//  DetailComposerPresentationController.swift
//  Accented
//
//  Created by Tiangong You on 5/20/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class DetailComposerPresentationController: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    let blurView = BlurView(frame: CGRect.zero)
    let duration = 0.3
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: .to)!
        if toViewController is DetailComposerViewController {
            performEntranceAnimation(using: transitionContext)
        } else {
            performExitAnimation(using: transitionContext)
        }
    }
    
    func performEntranceAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let composer = transitionContext.viewController(forKey: .to) as! DetailComposerViewController
        
        containerView.addSubview(blurView)
        containerView.addSubview(composer.view)
        
        // Prepare animaton
        composer.view.frame = containerView.bounds
        blurView.frame = containerView.bounds
        blurView.alpha = 0
        blurView.blurEffect = UIBlurEffect(style: .dark)
        composer.entranceAnimationWillBegin()
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.blurView.alpha = 1
            composer.performEntranceAnimation()
        }) { (finished) in
            let transitionCompleted = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(transitionCompleted)
            
            composer.entranceAnimationDidFinish()
        }
    }
    
    func performExitAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        let composer = transitionContext.viewController(forKey: .from) as! DetailComposerViewController

        // Prepare animaton
        composer.exitAnimationWillBegin()
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.blurView.alpha = 0
            composer.performExitAnimation()
        }) { (finished) in
            let transitionCompleted = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(transitionCompleted)
            composer.exitAnimationDidFinish()
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
