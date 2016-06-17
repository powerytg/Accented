//
//  DrawerService.swift
//  Accented
//
//  Created by You, Tiangong on 6/16/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DrawerService: NSObject {
    // Singleton instance
    static let sharedInstance = DrawerService()
    private override init() {
        super.init()
    }

    func addInteractiveGesture(animationContext : DrawerAnimationContext, delegate : DrawerGestureControllerDelegate) -> DrawerGestureController {
        return DrawerGestureController(animationContext : animationContext, delegate: delegate)
    }
    
    func presentDrawer(animationContext : DrawerAnimationContext) {
        let transitionDelegate = DrawerPresentationController(animationContext : animationContext)
        guard let container = animationContext.container else {
            return
        }
        
        animationContext.content.transitioningDelegate = transitionDelegate
        container.presentViewController(animationContext.content, animated: true, completion: nil)
    }
}
