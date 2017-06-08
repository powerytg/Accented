//
//  DrawerOpenGestureController.swift
//  Accented
//
//  Created by You, Tiangong on 6/16/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

protocol DrawerOpenGestureControllerDelegate : NSObjectProtocol {
    func drawerAnimationContextForInteractiveGesture() -> DrawerAnimationContext
}

class DrawerOpenGestureController: NSObject {
    
    private var animationContext : DrawerAnimationContext
    
    private var screenWidth : CGFloat
    private var screenHeight : CGFloat
    private var maxHorizontalTranslationPercentage : CGFloat
    private var maxVerticalTranslationPercentage : CGFloat
    
    weak var delegate : DrawerOpenGestureControllerDelegate?
    weak private var interactiveOpenAnimator : UIPercentDrivenInteractiveTransition?
    
    var swipeGesture : UIScreenEdgePanGestureRecognizer!
    
    required init(animationContext : DrawerAnimationContext, delegate : DrawerOpenGestureControllerDelegate) {
        self.animationContext = animationContext
        self.screenWidth = UIScreen.main.bounds.width
        self.screenHeight = UIScreen.main.bounds.height
        self.maxHorizontalTranslationPercentage = animationContext.drawerSize.width / screenWidth
        self.maxVerticalTranslationPercentage = animationContext.drawerSize.height / screenHeight
        self.delegate = delegate
        
        super.init()
        
        // Events
        self.swipeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(didReceiveOpenPanGesture(_:)))
        
        switch animationContext.anchor {
        case .left:
            swipeGesture.edges = .left
        case .right:
            swipeGesture.edges = .right
        case .bottom:
            swipeGesture.edges = .bottom
        }
        
        animationContext.container!.view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func didReceiveOpenPanGesture(_ gesture : UIScreenEdgePanGestureRecognizer) {
        var tx = gesture.location(in: gesture.view).x
        var ty = gesture.location(in: gesture.view).y
        
        guard let delegate = self.delegate else {
            return
        }
        
        // Since the gesture recognizer has a delay, chances are the user's finger has moved some distance before the transition can start
        // To smooth out the opening animation, we'll apply half of the empty space size for a "slow down" effect
        tx -= (screenWidth - animationContext.drawerSize.width) / 2
        ty -= (screenHeight - animationContext.drawerSize.height)
        var percentage : CGFloat
        
        switch animationContext.anchor {
        case .left:
            percentage = tx / animationContext.drawerSize.width
        case .right:
            percentage = (screenWidth - tx) / animationContext.drawerSize.width
        case .bottom:
            percentage = (screenHeight - ty) / animationContext.drawerSize.height
        }
        
        // Clamp the percentage to 0..1
        percentage = max(0, min(1, percentage))
        
        switch gesture.state {
        case .began:
            // Update animation context
            animationContext = delegate.drawerAnimationContextForInteractiveGesture()
            DrawerService.sharedInstance.presentDrawer(animationContext)
            self.interactiveOpenAnimator = animationContext.presentationController?.interactiveOpenAnimator
        case .ended:
            self.openGestureFinished(gesture)
        case .cancelled:
            interactiveOpenAnimator?.cancel()
        case .changed:
            interactiveOpenAnimator?.update(percentage)
        default: break
        }
    }
    
    private func openGestureFinished(_ gesture : UIScreenEdgePanGestureRecognizer) {
        let velocity = gesture.velocity(in: gesture.view)
        let travelDist : CGFloat
        let oppositeDirection : Bool
        
        switch animationContext.anchor {
        case .left:
            oppositeDirection = (velocity.x < 0)
            travelDist = abs(gesture.translation(in: gesture.view).x)
        case .right:
            oppositeDirection = (velocity.x > 0)
            travelDist = abs(gesture.translation(in: gesture.view).x)
        case .bottom:
            oppositeDirection = (velocity.y > 0)
            travelDist = abs(gesture.translation(in: gesture.view).y)
        }
        
        // If the velocity is on the opposite direction, dismiss the menu if the travel distance exceeds the threshold
        if oppositeDirection && travelDist >= animationContext.configurations.cancelTriggeringTranslation {
            interactiveOpenAnimator?.cancel()
        } else if self.isOpeningVelocityAccepted(velocity) {
            // If the velocity exceeds threahold, open the menu regardlessly
            interactiveOpenAnimator?.finish()
        } else {
            // If the travel distance does not meet the minimal requirement, cancel the animation
            if travelDist < animationContext.configurations.openTriggeringTranslation {
                interactiveOpenAnimator?.cancel()
            } else {
                interactiveOpenAnimator?.finish()
            }
        }
    }
    
    private func isOpeningVelocityAccepted(_ velocity : CGPoint) -> Bool {
        var v : CGFloat
        switch animationContext.anchor {
        case .left:
            v = velocity.x
        case .right:
            v = -velocity.x
        case .bottom:
            v = -velocity.y
        }
        
        return v >= animationContext.configurations.openTriggeringVelocity
    }
}
