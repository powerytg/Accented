//
//  DetailLightBoxPresentationController.swift
//  Accented
//
//  Created by Tiangong You on 8/8/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailLightBoxPresentationController: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {

    fileprivate var photo : PhotoModel
    fileprivate var sourceImageView : UIImageView
    fileprivate var useSourceImageViewAsProxy : Bool
    unowned fileprivate var presentingViewController : DetailGalleryViewController
    unowned fileprivate var presentedViewController : DetailLightBoxViewController
    
    init(presentingViewController : DetailGalleryViewController, presentedViewController : DetailLightBoxViewController, photo : PhotoModel, sourceImageView : UIImageView, useSourceImageViewAsProxy : Bool) {
        self.presentingViewController = presentingViewController
        self.presentedViewController = presentedViewController
        self.photo = photo
        self.sourceImageView = sourceImageView
        self.useSourceImageViewAsProxy = useSourceImageViewAsProxy
        super.init()
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
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
                        
            let proxyImagePosition = sourceImageView.convert(sourceImageView.bounds.origin, to: toViewController.view)
            proxyImageView.frame = CGRect(x: proxyImagePosition.x, y: proxyImagePosition.y, width: sourceImageView.bounds.width, height: sourceImageView.bounds.height)
        }
        
        containerView.addSubview(proxyImageView)
        
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [.calculationModeCubic], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                proxyImageView.frame = targetPhotoViewRect
                proxyImageView.transform = CGAffineTransform.identity
                fromViewController.view.alpha = 0
            })
            
            fromViewController.performLightBoxTransition()
            toViewController.performLightBoxTransition()
            
        }) { (finished) in
            let transitionCompleted = !transitionContext.transitionWasCancelled
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
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    
}
