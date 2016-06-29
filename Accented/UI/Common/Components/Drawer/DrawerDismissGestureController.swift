//
//  DrawerDismissGestureController.swift
//  Accented
//
//  Created by You, Tiangong on 6/29/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DrawerDismissGestureController: NSObject {
    
    private var animationContext : DrawerAnimationContext
    private var screenWidth : CGFloat
    private var screenHeight : CGFloat

    weak private var interactiveDismissAnimator : UIPercentDrivenInteractiveTransition?
    
    required init(animationContext : DrawerAnimationContext) {
        self.animationContext = animationContext
        self.screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        self.screenHeight = CGRectGetHeight(UIScreen.mainScreen().bounds)

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
    
    @objc private func didTapOnBackgroundView(sender : AnyObject) {
        // Because the tap action is never going to be interactive, we need to make sure that we disable the interactive property in the context so that the correct non-interactive dismissal animator will be used
        animationContext.interactive = false
        animationContext.content.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func didReceiveSwipeGesture(gesture : UIPanGestureRecognizer) {
        let tx = gesture.translationInView(gesture.view).x
        let ty = gesture.translationInView(gesture.view).y
        var percentage : CGFloat
        print(tx)
        switch animationContext.anchor {
        case .Left:
            percentage = tx / animationContext.drawerSize.width
        case .Right:
            percentage = -tx / animationContext.drawerSize.width
        case .Bottom:
            percentage = ty / animationContext.drawerSize.height
        }
        
        // Clamp the percentage to 0..1
        percentage = max(0, min(1, percentage))
        
        switch gesture.state {
        case .Began:
            // Lock down the interactive flag
            animationContext.interactive = true
            animationContext.content.dismissViewControllerAnimated(true, completion: nil)
            self.interactiveDismissAnimator = animationContext.presentationController?.interactiveDismissAnimator
        case .Ended:
            self.dismissGestureFinished(gesture)
        case .Cancelled:
            interactiveDismissAnimator?.cancelInteractiveTransition()
        case .Changed:
            interactiveDismissAnimator?.updateInteractiveTransition(percentage)
        default: break
        }
    }

    private func dismissGestureFinished(gesture : UIPanGestureRecognizer) {
//        let velocity = gesture.velocityInView(gesture.view)
//        let travelDist : CGFloat
//        let oppositeDirection : Bool
//        
//        switch animationContext.anchor {
//        case .Left:
//            oppositeDirection = (velocity.x < 0)
//            travelDist = abs(gesture.translationInView(gesture.view).x)
//        case .Right:
//            oppositeDirection = (velocity.x > 0)
//            travelDist = abs(gesture.translationInView(gesture.view).x)
//        case .Bottom:
//            oppositeDirection = (velocity.y > 0)
//            travelDist = abs(gesture.translationInView(gesture.view).y)
//        }
//        
//        // If the velocity is on the opposite direction, dismiss the menu if the travel distance exceeds the threshold
//        if oppositeDirection && travelDist >= animationContext.configurations.cancelTriggeringTranslation {
//            interactiveOpenAnimator?.cancelInteractiveTransition()
//        } else if self.isOpeningVelocityAccepted(velocity) {
//            // If the velocity exceeds threahold, open the menu regardlessly
//            interactiveOpenAnimator?.finishInteractiveTransition()
//        } else {
//            // If the travel distance does not meet the minimal requirement, cancel the animation
//            if travelDist < animationContext.configurations.openTriggeringTranslation {
//                interactiveOpenAnimator?.cancelInteractiveTransition()
//            } else {
//                interactiveOpenAnimator?.finishInteractiveTransition()
//            }
//        }
    }
}
