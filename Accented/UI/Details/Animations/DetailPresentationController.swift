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
    
    init(photo : PhotoModel, sourceImageView : UIImageView, fromViewController : UIViewController, toViewController : UIViewController) {
        self.photo = photo
        self.sourceImageView = sourceImageView
        self.fromView = fromViewController.view
        self.toView = toViewController.view
        super.init()
    }
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        let duration = self.transitionDuration(transitionContext)
        let animationOptions : UIViewAnimationOptions = .CurveEaseOut
        
        // Create a proxy image view
        let proxyImageView = UIImageView(image: sourceImageView.image)
        proxyImageView.contentMode = sourceImageView.contentMode
        let proxyImagePosition = sourceImageView.convertPoint(sourceImageView.bounds.origin, toView: toView)
        proxyImageView.frame = CGRectMake(proxyImagePosition.x, proxyImagePosition.y, CGRectGetWidth(sourceImageView.bounds), CGRectGetHeight(sourceImageView.bounds))
        containerView?.addSubview(proxyImageView)
        
        // Calculate the target frame for the photo view
        let targetPhotoViewRect = DetailOverviewSectionView.targetRectForPhotoView(photo)
        
        // Initially hide the target view controller
        containerView?.addSubview(toView)
        toView.alpha = 0
        
        UIView.animateWithDuration(duration, delay: 0, options: animationOptions, animations: { [weak self] in
            proxyImageView.frame = targetPhotoViewRect
            self?.fromView.alpha = 0            
        }) { (finished) in
            let transitionCompleted = !transitionContext.transitionWasCancelled()
            transitionContext.completeTransition(transitionCompleted)
        }
    }
}
