//
//  DrawerDismissGestureController.swift
//  Accented
//
//  Created by You, Tiangong on 6/29/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DrawerDismissGestureController: NSObject {
    
    fileprivate var animationContext : DrawerAnimationContext
    fileprivate var screenWidth : CGFloat
    fileprivate var screenHeight : CGFloat

    weak fileprivate var interactiveDismissAnimator : UIPercentDrivenInteractiveTransition?
    
    required init(animationContext : DrawerAnimationContext) {
        self.animationContext = animationContext
        self.screenWidth = UIScreen.main.bounds.width
        self.screenHeight = UIScreen.main.bounds.height

        super.init()
    }
    
    func installDismissalGestures() {
        let backgroundTap = UITapGestureRecognizer(target: self, action: #selector(didTapOnBackgroundView(_:)))
        animationContext.backgroundView?.addGestureRecognizer(backgroundTap)
        
        let backgroundSwipeGesture = UIPanGestureRecognizer(target: self, action: #selector(didReceiveSwipeGesture(_:)))
        animationContext.backgroundView?.addGestureRecognizer(backgroundSwipeGesture)
        
        let contentSwipeGesture = UIPanGestureRecognizer(target: self, action: #selector(didReceiveSwipeGesture(_:)))
        animationContext.content.view.addGestureRecognizer(contentSwipeGesture)
    }
    
    //MARK: Events
    
    @objc fileprivate func didTapOnBackgroundView(_ sender : AnyObject) {
        // Because the tap action is never going to be interactive, we need to make sure that we disable the interactive property in the context so that the correct non-interactive dismissal animator will be used
        animationContext.interactive = false
        animationContext.content.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func didReceiveSwipeGesture(_ gesture : UIPanGestureRecognizer) {
        let tx = gesture.translation(in: gesture.view).x
        let ty = gesture.translation(in: gesture.view).y
        var percentage : CGFloat
        
        switch animationContext.anchor {
        case .left:
            percentage = -tx / animationContext.drawerSize.width
        case .right:
            percentage = tx / animationContext.drawerSize.width
        case .bottom:
            percentage = ty / animationContext.drawerSize.height
        }
        
        // Clamp the percentage to 0..1
        percentage = max(0, min(1, percentage))
        
        switch gesture.state {
        case .began:
            // Lock down the interactive flag
            animationContext.interactive = true
            animationContext.content.dismiss(animated: true, completion: nil)
            self.interactiveDismissAnimator = animationContext.presentationController?.interactiveDismissAnimator
        case .ended:
            self.dismissGestureFinished(gesture)
            animationContext.interactive = true
        case .cancelled:
            interactiveDismissAnimator?.cancel()
            animationContext.interactive = false
        case .changed:
            interactiveDismissAnimator?.update(percentage)
        default: break
        }
    }

    fileprivate func dismissGestureFinished(_ gesture : UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: gesture.view)
        let travelDist : CGFloat
        let oppositeDirection : Bool
        
        switch animationContext.anchor {
        case .left:
            oppositeDirection = (velocity.x > 0)
            travelDist = abs(gesture.translation(in: gesture.view).x)
        case .right:
            oppositeDirection = (velocity.x < 0)
            travelDist = abs(gesture.translation(in: gesture.view).x)
        case .bottom:
            oppositeDirection = (velocity.y < 0)
            travelDist = abs(gesture.translation(in: gesture.view).y)
        }
        
        // If the velocity is on the opposite direction, dismiss the menu if the travel distance exceeds the threshold
        if oppositeDirection && travelDist >= animationContext.configurations.cancelTriggeringTranslation {
            interactiveDismissAnimator?.cancel()
        } else if self.isDismissalVelocityAccepted(velocity) {
            // If the velocity exceeds threahold, open the menu regardlessly
            interactiveDismissAnimator?.finish()
        } else {
            // If the travel distance does not meet the minimal requirement, cancel the animation
            if travelDist < animationContext.configurations.openTriggeringTranslation {
                interactiveDismissAnimator?.cancel()
            } else {
                interactiveDismissAnimator?.finish()
            }
        }
    }
    
    fileprivate func isDismissalVelocityAccepted(_ velocity : CGPoint) -> Bool {
        var v : CGFloat
        switch animationContext.anchor {
        case .left:
            v = -velocity.x
        case .right:
            v = velocity.x
        case .bottom:
            v = velocity.y
        }
        
        return v >= animationContext.configurations.dismissTriggeringTranslation
    }
}
