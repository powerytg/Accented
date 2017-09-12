//
//  MenuViewController.swift
//  Accented
//
//  Created by You, Tiangong on 8/24/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

protocol MenuDelegate : NSObjectProtocol {
    func didSelectMenuItem(_ menuItem : MenuItem)
}

class MenuViewController: UIViewController {
    
    private let paddingTop : CGFloat = 25
    private let paddingBottom : CGFloat = 25
    private let titlePaddingLeft : CGFloat = 20
    private let itemHeight : CGFloat = 46
    private let titleHeight : CGFloat = 40
    private var menuItems = [MenuItem]()
    private var renderers = [MenuItemRenderer]()
    private var titleLabel : UILabel!
    
    weak var delegate : MenuDelegate?
    
    init(_ menuItems : [MenuItem]) {
        self.menuItems = menuItems
        super.init(nibName: nil, bundle: nil)
        guard menuItems.count > 0 else { fatalError("Menu item count must be greater than zero") }
        
        view.backgroundColor = ThemeManager.sharedInstance.currentTheme.menuSheetBackgroundColor
        
        // Add a title label
        titleLabel = UILabel(frame : CGRect.zero)
        titleLabel.textColor = ThemeManager.sharedInstance.currentTheme.menuTitleColor
        titleLabel.font = ThemeManager.sharedInstance.currentTheme.menuTitleFont
        view.addSubview(titleLabel)
        
        // Create menu item renderers
        for item in menuItems {
            let renderer = MenuItemRenderer(item)
            renderers.append(renderer)
            view.addSubview(renderer)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(menuItemDidTap(_:)))
            renderer.addGestureRecognizer(tap)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var nextY : CGFloat = paddingTop
        if let title = self.title {
            titleLabel.text = title
            titleLabel.sizeToFit()
            
            var f = titleLabel.frame
            f.origin.x = titlePaddingLeft
            f.origin.y = paddingTop
            titleLabel.frame = f
            nextY += titleHeight
        } else {
            titleLabel.isHidden = true
        }
        
        for renderer in renderers {
            var f = renderer.frame
            f.size.width = view.bounds.size.width
            f.size.height = itemHeight
            f.origin.y = nextY
            renderer.frame = f
            
            nextY += itemHeight
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
        var height : CGFloat = itemHeight * CGFloat(menuItems.count) + paddingTop + paddingBottom
        if title != nil {
            height += titleHeight
        }
        
        return height
    }
    
    @objc private func menuItemDidTap(_ tap : UITapGestureRecognizer) {
        dismiss(animated: true) { [weak self] in
            if let selectedRenderer = tap.view {
                self?.delegate?.didSelectMenuItem((selectedRenderer as! MenuItemRenderer).menuItem)
            }
        }
    }
}
