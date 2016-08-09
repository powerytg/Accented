//
//  DetailLightBoxPresentationController.swift
//  Accented
//
//  Created by Tiangong You on 8/8/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailLightBoxPresentationController: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {

    private var photo : PhotoModel
    private var sourceImageView : UIImageView
    
    init(photo : PhotoModel, sourceImageView : UIImageView) {
        self.photo = photo
        self.sourceImageView = sourceImageView
        super.init()
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! DetailLightBoxViewController
        
        // Prepare entrance animation
        containerView?.addSubview(toViewController.view)
        toViewController.entranceAnimationWillBegin()
        
        // Create a proxy image view
        let targetPhotoViewRect = toViewController.desitinationRectForProxyView(photo)
        let proxyImageView = UIImageView(image: sourceImageView.image)
        proxyImageView.contentMode = .ScaleAspectFit
        let proxyImagePosition = sourceImageView.convertPoint(sourceImageView.bounds.origin, toView: toViewController.view)
        proxyImageView.frame = CGRectMake(proxyImagePosition.x, proxyImagePosition.y, CGRectGetWidth(sourceImageView.bounds), CGRectGetHeight(sourceImageView.bounds))
        containerView?.addSubview(proxyImageView)
        
        UIView.animateKeyframesWithDuration(0.3, delay: 0, options: [.CalculationModeCubic], animations: {
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.5, animations: {
                proxyImageView.frame = targetPhotoViewRect
                fromViewController.view.alpha = 0
            })
            
            toViewController.performEntranceAnimation()
            
        }) { (finished) in
            let transitionCompleted = !transitionContext.transitionWasCancelled()
            transitionContext.completeTransition(transitionCompleted)
            toViewController.entranceAnimationDidFinish()
            
            // Restore origin view controller
            fromViewController.view.alpha = 1
            
            // Remove proxy image
            proxyImageView.removeFromSuperview()
        }
    }
    
    // MARK : - UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    
}
