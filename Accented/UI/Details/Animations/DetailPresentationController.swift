//
//  DetailPresentationController.swift
//  Accented
//
//  Created by You, Tiangong on 7/11/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailPresentationController: NSObject, UIViewControllerAnimatedTransitioning {

    private var photo : PhotoModel
    private var fromView : UIView
    private var toView : UIView
    private var sourceImageView : UIImageView
    weak var galleryVC : DetailGalleryViewController?
    
    init(photo : PhotoModel, sourceImageView : UIImageView, fromViewController : UIViewController, toViewController : DetailGalleryViewController) {
        self.photo = photo
        self.sourceImageView = sourceImageView
        self.fromView = fromViewController.view
        self.toView = toViewController.view
        self.galleryVC = toViewController
        super.init()
    }
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        let galleryViewController = self.galleryVC!
        
        // Prepare entrance animation
        containerView?.addSubview(toView)
        galleryViewController.entranceAnimationWillBegin()

        // Create a proxy image view
        let targetPhotoViewRect = galleryViewController.desitinationRectForProxyView(photo)
        let proxyImageView = UIImageView(image: sourceImageView.image)
        proxyImageView.contentMode = sourceImageView.contentMode
        let proxyImagePosition = sourceImageView.convertPoint(sourceImageView.bounds.origin, toView: toView)
        proxyImageView.frame = CGRectMake(proxyImagePosition.x, proxyImagePosition.y, CGRectGetWidth(sourceImageView.bounds), CGRectGetHeight(sourceImageView.bounds))
        containerView?.addSubview(proxyImageView)

        UIView.animateKeyframesWithDuration(0.4, delay: 0, options: [.CalculationModeCubic], animations: { [weak self] in
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.5, animations: {
                proxyImageView.frame = targetPhotoViewRect
                self?.fromView.alpha = 0
            })
            
            // Let the detailVC handle the rest of animation
            self?.galleryVC?.performEntranceAnimation()
            
            }) { (finished) in
                let transitionCompleted = !transitionContext.transitionWasCancelled()
                transitionContext.completeTransition(transitionCompleted)
                galleryViewController.entranceAnimationDidFinish()
                
                // Remove proxy image
                proxyImageView.removeFromSuperview()
        }
    }
}
