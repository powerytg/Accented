//
//  DetailPresentationController.swift
//  Accented
//
//  Created by You, Tiangong on 7/11/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailPresentationController: NSObject, UIViewControllerAnimatedTransitioning {

    fileprivate var photo : PhotoModel
    fileprivate var fromView : UIView
    fileprivate var toView : UIView
    fileprivate var sourceImageView : UIImageView
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
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromViewController = transitionContext.viewController(forKey: .from)
        let galleryViewController = self.galleryVC!
        
        // Prepare entrance animation
        containerView.addSubview(toView)
        galleryViewController.entranceAnimationWillBegin()

        // Create a proxy image view
        let targetPhotoViewRect = galleryViewController.desitinationRectForProxyView(photo)
        let proxyImageView = UIImageView(image: sourceImageView.image)
        proxyImageView.contentMode = sourceImageView.contentMode
        let proxyImagePosition = sourceImageView.convert(sourceImageView.bounds.origin, to: toView)
        proxyImageView.frame = CGRect(x: proxyImagePosition.x, y: proxyImagePosition.y, width: sourceImageView.bounds.width, height: sourceImageView.bounds.height)
        containerView.addSubview(proxyImageView)

        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: [.calculationModeCubic], animations: { [weak self] in
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                fromViewController?.view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                proxyImageView.frame = targetPhotoViewRect
                self?.fromView.alpha = 0
            })
            
            // Let the detailVC handle the rest of animation
            self?.galleryVC?.performEntranceAnimation()
            
            }) { (finished) in
                let transitionCompleted = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(transitionCompleted)
                galleryViewController.entranceAnimationDidFinish()
                
                // Restore origin view controller
                fromViewController?.view.alpha = 1
                fromViewController?.view.transform = CGAffineTransform.identity
                
                // Remove proxy image
                proxyImageView.removeFromSuperview()
        }
    }
}
