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
    private var useSourceImageViewAsProxy : Bool
    unowned private var presentingViewController : DetailGalleryViewController
    unowned private var presentedViewController : DetailLightBoxViewController
    
    init(presentingViewController : DetailGalleryViewController, presentedViewController : DetailLightBoxViewController, photo : PhotoModel, sourceImageView : UIImageView, useSourceImageViewAsProxy : Bool) {
        self.presentingViewController = presentingViewController
        self.presentedViewController = presentedViewController
        self.photo = photo
        self.sourceImageView = sourceImageView
        self.useSourceImageViewAsProxy = useSourceImageViewAsProxy
        super.init()
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        let fromViewController = self.presentingViewController
        let toViewController = self.presentedViewController
        
        // Prepare entrance animation
        containerView.addSubview(toViewController.view)
        fromViewController.lightBoxTransitionWillBegin()
        toViewController.lightBoxTransitionWillBegin()
        
        // Create a proxy image view
        let targetPhotoViewRect = toViewController.desitinationRectForSelectedLightBoxPhoto(photo)
        var proxyImageView : UIImageView
        if useSourceImageViewAsProxy {
            proxyImageView = sourceImageView
        } else {
            proxyImageView = UIImageView(image: sourceImageView.image)
            proxyImageView.transform = sourceImageView.transform
            proxyImageView.contentMode = sourceImageView.contentMode
                        
            let proxyImagePosition = sourceImageView.convertPoint(sourceImageView.bounds.origin, toView: toViewController.view)
            proxyImageView.frame = CGRectMake(proxyImagePosition.x, proxyImagePosition.y, CGRectGetWidth(sourceImageView.bounds), CGRectGetHeight(sourceImageView.bounds))
        }
        
        containerView.addSubview(proxyImageView)
        
        UIView.animateKeyframesWithDuration(0.3, delay: 0, options: [.CalculationModeCubic], animations: {
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.5, animations: {
                proxyImageView.frame = targetPhotoViewRect
                proxyImageView.transform = CGAffineTransformIdentity
                fromViewController.view.alpha = 0
            })
            
            fromViewController.performLightBoxTransition()
            toViewController.performLightBoxTransition()
            
        }) { (finished) in
            let transitionCompleted = !transitionContext.transitionWasCancelled()
            transitionContext.completeTransition(transitionCompleted)
            fromViewController.lightboxTransitionDidFinish()
            toViewController.lightboxTransitionDidFinish()
            
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
