//
//  DrawerPresentationController.swift
//  Accented
//
//  Created by You, Tiangong on 6/17/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DrawerPresentationController: UIPresentationController, UIViewControllerTransitioningDelegate {
    
    // Animation context
    private var animationContext : DrawerAnimationContext
    
    // Curtain view
    private var curtainView = UIView()
    
    // Open animator
    var openAnimator : DrawerOpenAnimator?
    
    // Close animator
    var dismissAnimator : DrawerDismissAnimator?
    
    // Interactive open animator
    var interactiveOpenAnimator : DrawerOpenAnimator?
    
    // Interactive close animator
    var interactiveDismissAnimator : DrawerDismissAnimator?

    required init(animationContext : DrawerAnimationContext) {
        self.animationContext = animationContext
        super.init(presentedViewController: animationContext.content, presentingViewController: animationContext.container!)
        
        animationContext.presentationController = self
        
        // Animators
        self.openAnimator = DrawerOpenAnimator(animationContext : animationContext)
        self.dismissAnimator = DrawerDismissAnimator(animationContext : animationContext)
        self.interactiveOpenAnimator = DrawerOpenAnimator(animationContext : animationContext)
        self.interactiveDismissAnimator = DrawerDismissAnimator(animationContext : animationContext)
        
        // Initialization
        animationContext.content.modalPresentationStyle = .Custom
        animationContext.content.transitioningDelegate = self
    }
    
    //MARK: UIPresentationController
    
    override func presentationTransitionWillBegin() {
        // Setup curtain view
        containerView!.addSubview(curtainView)
        curtainView.userInteractionEnabled = true
        curtainView.alpha = 0
        curtainView.backgroundColor = UIColor.blackColor()
        curtainView.translatesAutoresizingMaskIntoConstraints = false
        curtainView.widthAnchor.constraintEqualToAnchor(self.containerView!.widthAnchor).active = true
        curtainView.heightAnchor.constraintEqualToAnchor(self.containerView!.heightAnchor).active = true
        
        // Setup drawer
        let contentView = presentedViewController.view
        containerView!.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraintEqualToConstant(animationContext.drawerSize.width).active = true
        contentView.heightAnchor.constraintEqualToConstant(animationContext.drawerSize.height).active = true
        
        switch animationContext.anchor {
        case .Left:
            contentView.leadingAnchor.constraintEqualToAnchor(containerView!.leadingAnchor).active = true
        case .Right:
            contentView.trailingAnchor.constraintEqualToAnchor(containerView!.trailingAnchor).active = true
        case .Bottom:
            contentView.bottomAnchor.constraintEqualToAnchor(containerView!.bottomAnchor).active = true
        }
        
        switch animationContext.anchor {
        case .Left:
            contentView.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(contentView.bounds), 0)
        case .Right:
            contentView.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(contentView.bounds), 0)
        case .Bottom:
            contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(contentView.bounds))
        }

        // Perform the curtain view animation along with the transition
        let curtainAlpha = animationContext.configurations.curtainAlpha
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ [weak self] (context) in
            self?.curtainView.alpha = curtainAlpha
            }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(completed: Bool) {
        if completed {
            // Reset the animation context to non-interactive
            // This is important as the interactive should only be set after a gesture detection
            animationContext.interactive = false
            
            // Events
            let curtainTap = UITapGestureRecognizer(target: self, action: #selector(didTapOnCurtainView(_:)))
            curtainView.addGestureRecognizer(curtainTap)

        } else {
            curtainView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        // Perform the curtain view animation along with the transition
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ [weak self] (context) in
            self?.curtainView.alpha = 0
            }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(completed: Bool) {
        if completed {
            curtainView.removeFromSuperview()
        } else {
            curtainView.alpha = animationContext.configurations.curtainAlpha
        }
    }
    
    //MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.openAnimator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.dismissAnimator
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return animationContext.interactive ? self.interactiveOpenAnimator : nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return animationContext.interactive ? self.interactiveDismissAnimator : nil
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return self
    }
    
    //MARK: Events
    
    func didTapOnCurtainView(sender : AnyObject) {
        // Because the tap action is never going to be interactive, we need to make sure that we disable the interactive property in the context so that the correct non-interactive dismissal animator will be used
        animationContext.interactive = false
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }

}
