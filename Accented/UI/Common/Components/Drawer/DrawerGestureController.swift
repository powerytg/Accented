//
//  DrawerGestureController.swift
//  Accented
//
//  Created by You, Tiangong on 6/16/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

protocol DrawerGestureControllerDelegate : NSObjectProtocol {
    func drawerViewControllerForInteractiveGesture() -> DrawerViewController
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
        self.swipeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(didReceiveEdgePanGesture(_:)))
        
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
    
    @objc func didReceiveEdgePanGesture(gesture : UIScreenEdgePanGestureRecognizer) {
        var tx = gesture.locationInView(gesture.view).x
        var ty = gesture.locationInView(gesture.view).y        
        var travelDist : CGFloat
        
        // Since the drawer may not cover the entire screen, we need to compensate the gap area
        tx -= (screenWidth - animationContext.drawerSize.width)
        ty -= (screenHeight - animationContext.drawerSize.height)
        
        var percentage : CGFloat
        
        switch animationContext.anchor {
        case .Left:
            percentage = tx / animationContext.drawerSize.width
            travelDist = abs(tx)
        case .Right:
            percentage = (screenWidth - tx) / animationContext.drawerSize.width
            travelDist = abs(screenWidth - tx)
        case .Bottom:
            percentage = (screenHeight - ty) / animationContext.drawerSize.height
            travelDist = abs(screenHeight - ty)
        }
        
        // Camp the percentage to 0..1
        percentage = max(0, min(1, percentage))
        
        print(percentage)
        switch gesture.state {
        case .Began:
            let drawer = delegate?.drawerViewControllerForInteractiveGesture()
            DrawerService.sharedInstance.presentDrawer(drawer!, container: animationContext.container!)
            self.interactiveOpenAnimator = drawer!.interactiveOpenAnimator
        case .Ended:
            // If the travel distance does not meet the minimal requirement, cancel the animation
//            if travelDist < animationContext.configurations.translationBeginThreshold {
//                interactiveOpenAnimator?.cancelInteractiveTransition()
//            } else {
//                interactiveOpenAnimator?.finishInteractiveTransition()
//            }
            interactiveOpenAnimator?.finishInteractiveTransition()
        case .Cancelled:
            interactiveOpenAnimator?.cancelInteractiveTransition()
        case .Changed:
            interactiveOpenAnimator?.updateInteractiveTransition(percentage)
        default:
            print("begin")
        }
    }
    
}
