//
//  DrawerViewController.swift
//  Accented
//
//  Created by Tiangong You on 6/5/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

enum DrawerAnchor {
    case Left
    case Right
    case Bottom
}

class DrawerViewController: UIViewController {

    // Drawer anchor, deffault to pinning to left
    private var anchor : DrawerAnchor = .Left
    
    // Curtain view
    private var curtainView = UIView()
    
    // Hosted view controller
    private var drawer : UIViewController
    
    // Drawer percentage width
    static let drawerPercentageWidth : CGFloat = 0.8
    
    init(drawer : UIViewController, anchor : DrawerAnchor = .Left) {
        self.drawer = drawer
        self.anchor = anchor
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup curtain view
        self.view.addSubview(curtainView)
        curtainView.userInteractionEnabled = true
        curtainView.alpha = 0
        curtainView.backgroundColor = UIColor.blackColor()
        curtainView.translatesAutoresizingMaskIntoConstraints = false
        curtainView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        curtainView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor).active = true
                
        // Setup host view
        addChildViewController(drawer)
        self.view.addSubview(drawer.view)
        drawer.view.translatesAutoresizingMaskIntoConstraints = false
        drawer.didMoveToParentViewController(self)
        drawer.view.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor).active = true
        drawer.view.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: DrawerViewController.drawerPercentageWidth).active = true
        drawer.view.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor).active = true
        
        // Events
        let curtainTap = UITapGestureRecognizer(target: self, action: #selector(didTapOnCurtainView(_:)))
        curtainView.addGestureRecognizer(curtainTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        drawer.view.layer.shadowPath = UIBezierPath(rect: drawer.view.bounds).CGPath
        drawer.view.layer.shadowColor = UIColor.blackColor().CGColor
        drawer.view.layer.shadowOpacity = 0.65;
        drawer.view.layer.shadowRadius = 5
        drawer.view.layer.shadowOffset = CGSizeMake(-3, 0)
    }

    // MARK: Animations
    
    func willPerformOpenAnimation() {
        switch anchor {
        case .Left:
            drawer.view.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(drawer.view.bounds), 0)
        case .Right:
            drawer.view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(drawer.view.bounds), 0)
        case .Bottom:
            drawer.view.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(drawer.view.bounds))
        }
    }
    
    func performanceOpenAnimation() {
        curtainView.alpha = 0.7
        drawer.view.transform = CGAffineTransformIdentity
    }
    
    func willPerformDismissAnimation() {
        // Do nothing
    }
    
    func performanceDismissAnimation() {
        curtainView.alpha = 0
        switch anchor {
        case .Left:
            drawer.view.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(drawer.view.bounds), 0)
        case .Right:
            drawer.view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(drawer.view.bounds), 0)
        case .Bottom:
            drawer.view.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(drawer.view.bounds))
        }
    }

    //MARK: Events
    
    func didTapOnCurtainView(sender : AnyObject) {
        self.dismissViewControllerAnimated(true) { 
            // Ignore
        }
    }
    
}
