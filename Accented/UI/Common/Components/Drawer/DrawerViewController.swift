//
//  DrawerViewController.swift
//  Accented
//
//  Created by Tiangong You on 6/5/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

enum DrawerAnchor {
    case Left
    case Right
    case Bottom
}

class DrawerViewController: UIViewController, UIViewControllerTransitioningDelegate {

    // Animation context
    private var animationContext : DrawerAnimationContext
    
    // Curtain view
    private var curtainView = UIView()
    
    // Content view controller
    private var contentViewcontroller : UIViewController;
    
    // Open animator
    var openAnimator : DrawerOpenAnimator?
    
    // Close animator
    var dismissAnimator : DrawerDismissAnimator?
    
    // Interactive open animator
    var interactiveOpenAnimator : DrawerOpenAnimator?
    
    // Interactive close animator
    var interactiveDismissAnimator : DrawerDismissAnimator?
    
    init(content : UIViewController, animationContext : DrawerAnimationContext) {
        self.animationContext = animationContext
        self.contentViewcontroller = content
        super.init(nibName: nil, bundle: nil)
        
        // Animators
        self.openAnimator = DrawerOpenAnimator(animationContext : animationContext)
        self.dismissAnimator = DrawerDismissAnimator(animationContext : animationContext)
        self.interactiveOpenAnimator = DrawerOpenAnimator(animationContext : animationContext)
        self.interactiveDismissAnimator = DrawerDismissAnimator(animationContext : animationContext)
        
        // Initialization
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = self
        self.animationContext.drawer = self
        self.animationContext.content = content
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup curtain view
        self.view.addSubview(curtainView)
        curtainView.userInteractionEnabled = true
        curtainView.alpha = 0
        curtainView.backgroundColor = UIColor.blackColor()
        curtainView.translatesAutoresizingMaskIntoConstraints = false
        curtainView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        curtainView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor).active = true
                
        // Setup host view
        let contentView = contentViewcontroller.view
        addChildViewController(contentViewcontroller)
        self.view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraintEqualToConstant(animationContext.drawerSize.width).active = true
        contentView.heightAnchor.constraintEqualToConstant(animationContext.drawerSize.height).active = true
        contentViewcontroller.didMoveToParentViewController(self)
        
        switch animationContext.anchor {
        case .Left:
            contentView.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor).active = true
        case .Right:
            contentView.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor).active = true
        case .Bottom:
            contentView.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
        }
        
        // Events
        let curtainTap = UITapGestureRecognizer(target: self, action: #selector(didTapOnCurtainView(_:)))
        curtainView.addGestureRecognizer(curtainTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let contentView = contentViewcontroller.view
        contentView.layer.shadowPath = UIBezierPath(rect: contentViewcontroller.view.bounds).CGPath
        contentView.layer.shadowColor = UIColor.blackColor().CGColor
        contentView.layer.shadowOpacity = 0.65;
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowOffset = CGSizeMake(-3, 0)
    }

    // MARK: Animations
    
    func willPerformOpenAnimation() {
        let contentView = contentViewcontroller.view
        switch animationContext.anchor {
        case .Left:
            contentView.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(contentView.bounds), 0)
        case .Right:
            contentView.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(contentView.bounds), 0)
        case .Bottom:
            contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(contentView.bounds))
        }
    }
    
    func performanceOpenAnimation() {
        curtainView.alpha = 0.7
        contentViewcontroller.view.transform = CGAffineTransformIdentity
    }
    
    func willPerformDismissAnimation() {
        // Do nothing
    }
    
    func performanceDismissAnimation() {
        let contentView = contentViewcontroller.view
        curtainView.alpha = 0
        switch animationContext.anchor {
        case .Left:
            contentView.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(contentView.bounds), 0)
        case .Right:
            contentView.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(contentView.bounds), 0)
        case .Bottom:
            contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(contentView.bounds))
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
    
    //MARK: Events
    
    func didTapOnCurtainView(sender : AnyObject) {
        // Disable interactive transition
        animationContext.interactive = false
        
        self.dismissViewControllerAnimated(true) { 
            // Ignore
        }
    }

}
