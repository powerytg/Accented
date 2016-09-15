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
    fileprivate override init() {
        super.init()
    }

    func addInteractiveGesture(_ animationContext : DrawerAnimationContext, delegate : DrawerOpenGestureControllerDelegate) -> DrawerOpenGestureController {
        return DrawerOpenGestureController(animationContext : animationContext, delegate: delegate)
    }
    
    func presentDrawer(_ animationContext : DrawerAnimationContext) {
        let transitionDelegate = DrawerPresentationController(animationContext : animationContext)
        guard let container = animationContext.container else {
            return
        }
        
        animationContext.content.transitioningDelegate = transitionDelegate
        container.present(animationContext.content, animated: true, completion: nil)
    }
}
