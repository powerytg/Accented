//
//  DetailCommentsPresentationController.swift
//  Accented
//
//  Created by Tiangong You on 5/20/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class DetailCommentsPresentationController: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    let duration = 0.3
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: .to)!
        if toViewController is DetailComposerViewController {
            // Transition to comments VC
        } else {
            // Exit from comments VC
            
        }
    }
}
