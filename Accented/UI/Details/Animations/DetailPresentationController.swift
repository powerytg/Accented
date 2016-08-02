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
    weak var detailVC : DetailViewController?
    
    init(photo : PhotoModel, sourceImageView : UIImageView, fromViewController : UIViewController, toViewController : DetailViewController) {
        self.photo = photo
        self.sourceImageView = sourceImageView
        self.fromView = fromViewController.view
        self.toView = toViewController.view
        self.detailVC = toViewController
        super.init()
    }
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        let detailViewController = self.detailVC!
        
        // Prepare entrance animation
        containerView?.addSubview(toView)
        detailVC?.entranceAnimationWillBegin()

        // Create a proxy image view
        let targetPhotoViewRect = detailVC!.desitinationRectForProxyView(photo)
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
            self?.detailVC?.performEntranceAnimation()
            
            }) { (finished) in
                let transitionCompleted = !transitionContext.transitionWasCancelled()
                transitionContext.completeTransition(transitionCompleted)
                detailViewController.entranceAnimationDidFinish()
                
                // Remove proxy image
                proxyImageView.removeFromSuperview()
        }
    }
}
