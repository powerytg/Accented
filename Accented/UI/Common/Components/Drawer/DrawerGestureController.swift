//
//  DrawerGestureController.swift
//  Accented
//
//  Created by You, Tiangong on 6/16/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

protocol DrawerGestureControllerDelegate : NSObjectProtocol {
    func drawerAnimationContextForInteractiveGesture() -> DrawerAnimationContext
}

class DrawerGestureController: NSObject {

    private var animationContext : DrawerAnimationContext
    
    private var screenWidth : CGFloat
    private var screenHeight : CGFloat
    private var maxHorizontalTranslationPercentage : CGFloat
    private var maxVerticalTranslationPercentage : CGFloat
    
    weak var delegate : DrawerGestureControllerDelegate?
    weak private var interactiveOpenAnimator : UIPercentDrivenInteractiveTransition?
    
    var swipeGesture : UIScreenEdgePanGestureRecognizer!
    
    required init(animationContext : DrawerAnimationContext, delegate : DrawerGestureControllerDelegate) {
        self.animationContext = animationContext
        self.screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        self.screenHeight = CGRectGetHeight(UIScreen.mainScreen().bounds)
        self.maxHorizontalTranslationPercentage = animationContext.drawerSize.width / screenWidth
        self.maxVerticalTranslationPercentage = animationContext.drawerSize.height / screenHeight
        self.delegate = delegate
        
        super.init()
        
        // Events
        self.swipeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(didReceiveOpenPanGesture(_:)))
        
        switch animationContext.anchor {
        case .Left:
            swipeGesture.edges = .Left
        case .Right:
            swipeGesture.edges = .Right
        case .Bottom:
            swipeGesture.edges = .Bottom
        }
        
        animationContext.container!.view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func didReceiveOpenPanGesture(gesture : UIScreenEdgePanGestureRecognizer) {
        var tx = gesture.locationInView(gesture.view).x
        var ty = gesture.locationInView(gesture.view).y
        
        guard let delegate = self.delegate else {
            return
        }
        
        // Since the gesture recognizer has a delay, chances are the user's finger has moved some distance before the transition can start
        // To smooth out the opening animation, we'll apply half of the empty space size for a "slow down" effect
        tx -= (screenWidth - animationContext.drawerSize.width) / 2
        ty -= (screenHeight - animationContext.drawerSize.height)
        var percentage : CGFloat
        
        switch animationContext.anchor {
        case .Left:
            percentage = tx / animationContext.drawerSize.width
        case .Right:
            percentage = (screenWidth - tx) / animationContext.drawerSize.width
        case .Bottom:
            percentage = (screenHeight - ty) / animationContext.drawerSize.height
        }
        
        // Camp the percentage to 0..1
        percentage = max(0, min(1, percentage))
        
        switch gesture.state {
        case .Began:
            // Update animation context
            animationContext = delegate.drawerAnimationContextForInteractiveGesture()
            DrawerService.sharedInstance.presentDrawer(animationContext)
            self.interactiveOpenAnimator = animationContext.presentationController?.interactiveOpenAnimator
        case .Ended:
            self.openGestureFinished(gesture)
        case .Cancelled:
            interactiveOpenAnimator?.cancelInteractiveTransition()
        case .Changed:
            interactiveOpenAnimator?.updateInteractiveTransition(percentage)
        default: break
        }
    }
    
    private func openGestureFinished(gesture : UIScreenEdgePanGestureRecognizer) {
        let velocity = gesture.velocityInView(gesture.view)
        let travelDist : CGFloat
        let oppositeDirection : Bool
        
        switch animationContext.anchor {
        case .Left:
            oppositeDirection = (velocity.x < 0)
            travelDist = abs(gesture.translationInView(gesture.view).x)
        case .Right:
            oppositeDirection = (velocity.x > 0)
            travelDist = abs(gesture.translationInView(gesture.view).x)
        case .Bottom:
            oppositeDirection = (velocity.y > 0)
            travelDist = abs(gesture.translationInView(gesture.view).y)
        }

        // If the velocity is on the opposite direction, dismiss the menu if the travel distance exceeds the threshold
        if oppositeDirection && travelDist >= animationContext.configurations.cancelTriggeringTranslation {
            interactiveOpenAnimator?.cancelInteractiveTransition()
        } else if self.isOpeningVelocityAccepted(velocity) {
            // If the velocity exceeds threahold, open the menu regardlessly
            interactiveOpenAnimator?.finishInteractiveTransition()
        } else {
            // If the travel distance does not meet the minimal requirement, cancel the animation
            if travelDist < animationContext.configurations.openTriggeringTranslation {
                interactiveOpenAnimator?.cancelInteractiveTransition()
            } else {
                interactiveOpenAnimator?.finishInteractiveTransition()
            }
        }
    }
    
    private func isOpeningVelocityAccepted(velocity : CGPoint) -> Bool {
        var v : CGFloat
        switch animationContext.anchor {
        case .Left:
            v = velocity.x
        case .Right:
            v = -velocity.x
        case .Bottom:
            v = -velocity.y
        }
        
        return v >= animationContext.configurations.openTriggeringVelocity
    }
}
