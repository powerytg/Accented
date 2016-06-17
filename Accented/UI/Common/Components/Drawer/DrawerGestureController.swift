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
    
    private var anchor : DrawerAnchor
    private var drawerSize : CGSize
    private var screenWidth : CGFloat
    private var screenHeight : CGFloat
    private var maxHorizontalTranslationPercentage : CGFloat
    private var maxVerticalTranslationPercentage : CGFloat
    
    weak var delegate : DrawerGestureControllerDelegate?
    weak private var interactiveOpenAnimator : UIPercentDrivenInteractiveTransition?
    
    // Weak reference to the drawer view controller
    weak private var drawer : DrawerViewController?
    
    // Weak reference to the container view controller
    weak private var container : UIViewController?
    
    required init(container : UIViewController, anchor : DrawerAnchor, drawerSize : CGSize, delegate : DrawerGestureControllerDelegate) {
        self.anchor = anchor
        self.drawerSize = drawerSize
        self.screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        self.screenHeight = CGRectGetHeight(UIScreen.mainScreen().bounds)
        self.maxHorizontalTranslationPercentage = drawerSize.width / screenWidth
        self.maxVerticalTranslationPercentage = drawerSize.height / screenHeight
        
        super.init()
        
        // Events
        let swipeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(didReceiveEdgePanGesture(_:)))
        
        switch anchor {
        case .Left:
            swipeGesture.edges = .Left
        case .Right:
            swipeGesture.edges = .Right
        case .Bottom:
            swipeGesture.edges = .Bottom
        }
        
        container.view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func didReceiveEdgePanGesture(gesture : UIScreenEdgePanGestureRecognizer) {
        let tx = gesture.locationInView(gesture.view).x
        let ty = gesture.locationInView(gesture.view).y
        
        var percentage : CGFloat
        
        switch self.anchor {
        case .Left:
            percentage = min(maxHorizontalTranslationPercentage, tx / drawerSize.width)
        case .Right:
            percentage = min(maxHorizontalTranslationPercentage, tx / drawerSize.width)
        case .Bottom:
            percentage = min(maxVerticalTranslationPercentage, ty / drawerSize.height)            
        }
        
        switch gesture.state {
        case .Began:
            self.drawer = delegate?.drawerViewControllerForInteractiveGesture()
            self.interactiveOpenAnimator = self.drawer?.interactiveOpenAnimator
            DrawerService.sharedInstance.presentDrawer(self.drawer!, container: self.container!)
        case .Ended:
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
