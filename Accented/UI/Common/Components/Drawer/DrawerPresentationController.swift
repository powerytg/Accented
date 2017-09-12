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
    private var curtainView : UIView!
    
    // Open animator
    var openAnimator : DrawerOpenAnimator?
    
    // Close animator
    var dismissAnimator : DrawerDismissAnimator?
    
    // Interactive open animator
    var interactiveOpenAnimator : DrawerOpenAnimator?
    
    // Interactive close animator
    var interactiveDismissAnimator : DrawerDismissAnimator?

    // Dismissal gesture controller
    private var dismissGestureController : DrawerDismissGestureController?
    
    required init(animationContext : DrawerAnimationContext) {
        self.animationContext = animationContext
        super.init(presentedViewController: animationContext.content, presenting: animationContext.container!)
        
        // Create curtain view
        if ThemeManager.sharedInstance.currentTheme.drawerUseBlurBackground {
            let blurView = BlurView(frame: CGRect.zero)
            curtainView = blurView
        } else {
            curtainView = UIView()
        }
        
        animationContext.presentationController = self
        animationContext.backgroundView = curtainView
        
        // Animators
        self.openAnimator = DrawerOpenAnimator(animationContext : animationContext)
        self.dismissAnimator = DrawerDismissAnimator(animationContext : animationContext)
        self.interactiveOpenAnimator = DrawerOpenAnimator(animationContext : animationContext)
        self.interactiveDismissAnimator = DrawerDismissAnimator(animationContext : animationContext)
        
        // Initialization
        animationContext.content.modalPresentationStyle = .custom
        animationContext.content.transitioningDelegate = self
    }
    
    //MARK: UIPresentationController
    
    override func presentationTransitionWillBegin() {
        // Setup curtain view
        containerView!.addSubview(curtainView)
        curtainView.isUserInteractionEnabled = true
        curtainView.alpha = 0
        curtainView.backgroundColor = UIColor.black
        curtainView.translatesAutoresizingMaskIntoConstraints = false
        curtainView.widthAnchor.constraint(equalTo: self.containerView!.widthAnchor).isActive = true
        curtainView.heightAnchor.constraint(equalTo: self.containerView!.heightAnchor).isActive = true
        
        // Setup drawer
        let contentView = presentedViewController.view
        containerView!.addSubview(contentView!)
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        contentView?.widthAnchor.constraint(equalToConstant: animationContext.drawerSize.width).isActive = true
        contentView?.heightAnchor.constraint(equalToConstant: animationContext.drawerSize.height).isActive = true
        
        switch animationContext.anchor {
        case .left:
            contentView?.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor).isActive = true
        case .right:
            contentView?.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor).isActive = true
        case .bottom:
            contentView?.bottomAnchor.constraint(equalTo: containerView!.bottomAnchor).isActive = true
        }
        
        switch animationContext.anchor {
        case .left:
            contentView?.transform = CGAffineTransform(translationX: -(contentView?.bounds.width)!, y: 0)
        case .right:
            contentView?.transform = CGAffineTransform(translationX: (contentView?.bounds.width)!, y: 0)
        case .bottom:
            contentView?.transform = CGAffineTransform(translationX: 0, y: (contentView?.bounds.height)!)
        }

        // Perform the curtain view animation along with the transition
        let curtainAlpha = animationContext.configurations.curtainAlpha
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] (context) in
            self?.curtainView.alpha = curtainAlpha
            }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed {
            // Reset the animation context to non-interactive
            // This is important as the interactive should only be set after a gesture detection
            animationContext.interactive = false
            
            // Install dismissal gestures
            dismissGestureController = DrawerDismissGestureController(animationContext: animationContext)
            dismissGestureController!.installDismissalGestures()
        } else {
            curtainView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        // Perform the curtain view animation along with the transition
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] (context) in
            self?.curtainView.alpha = 0
            }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            curtainView.removeFromSuperview()
        } else {
            curtainView.alpha = animationContext.configurations.curtainAlpha
        }
    }
    
    //MARK: UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.openAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.dismissAnimator
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return animationContext.interactive ? self.interactiveOpenAnimator : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return animationContext.interactive ? self.interactiveDismissAnimator : nil
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self
    }
}
