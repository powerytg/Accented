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
    
    func presentDrawer(drawer : DrawerViewController, container : UIViewController) {
        container.presentViewController(drawer, animated: true, completion: nil)
    }
}
