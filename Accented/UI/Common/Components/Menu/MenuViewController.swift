//
//  MenuViewController.swift
//  Accented
//
//  Created by You, Tiangong on 8/24/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    private let itemHeight : CGFloat = 24
    private var menuItems = [MenuItem]()
    private var renderers = [MenuItemRenderer]()
    
    init(_ menuItems : [MenuItem]) {
        self.menuItems = menuItems
        super.init(nibName: nil, bundle: nil)
        guard menuItems.count > 0 else { fatalError("Menu item count must be greater than zero") }
        
        view.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        
        // Create menu item renderers
        for item in menuItems {
            let renderer = MenuItemRenderer(item)
            renderers.append(renderer)
            view.addSubview(renderer)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        for (index, renderer) in renderers.enumerated() {
            var f = renderer.frame
            f.size.width = view.bounds.size.width
            f.size.height = itemHeight
            f.origin.y = itemHeight * CGFloat(index)
            renderer.frame = f
        }
    }
    
    func show() {
        guard let topVC = NavigationService.sharedInstance.topViewController() else { return }
        
        let animationContext = DrawerAnimationContext(content: self)
        animationContext.anchor = .bottom
        animationContext.container = topVC
        animationContext.drawerSize = CGSize(width: UIScreen.main.bounds.size.width, height: estimatedHeight())
        DrawerService.sharedInstance.presentDrawer(animationContext)
    }
    
    private func estimatedHeight() -> CGFloat {
        return itemHeight * CGFloat(menuItems.count)
    }
}
