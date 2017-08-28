//
//  MainMenuAuthenticatedUserSectionView.swift
//  Accented
//
//  Main menu section for authenticated user
//
//  Created by Tiangong You on 8/27/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class MainMenuAuthenticatedUserSectionView: SectionViewBase {

    private let rowHeight : CGFloat = 32
    private let paddingTop : CGFloat = 32
    private let separatorHeight : CGFloat = 16
    
    let menuOptions = [MenuItem("Search", image : UIImage(named: "SearchButtonMainMenu")),
                       MenuSeparator(),
                       MenuItem("My Photos"),
                       MenuItem("My Galleries"),
                       MenuItem("My Profile"),
                       MenuSeparator(),
                       MenuItem("My Friends"),
                       MenuItem("My Friends' Photos"),
                       MenuSeparator(),
                       MenuItem("Pearl Cam"),
                       MenuSeparator(),
                       MenuItem("Sign Out")]
    
    var renderers = [MainMenuItemRenderer]()
    
    override func initialize() {
        super.initialize()
        
        for item in menuOptions {
            let renderer = MainMenuItemRenderer(item)
            contentView.addSubview(renderer)
            renderers.append(renderer)
        }
    }
    
    override func calculateContentHeight(maxWidth: CGFloat) -> CGFloat {
        var totalHeight : CGFloat = 0
        for item in menuOptions {
            if item is MenuSeparator {
                totalHeight += separatorHeight
            } else {
                totalHeight += rowHeight
            }
        }
        
        return totalHeight + paddingTop
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        var nextY : CGFloat = paddingTop
        for renderer in renderers {
            var f = renderer.frame
            f.origin.x = contentLeftPadding
            f.origin.y = nextY
            f.size.width = contentView.bounds.width - contentLeftPadding - contentRightPadding

            if renderer.menuItem is MenuSeparator {
                f.size.height = separatorHeight
            } else {
                f.size.height = rowHeight
            }
            
            renderer.frame = f
            
            if renderer.menuItem is MenuSeparator {
                nextY += separatorHeight
            } else {
                nextY += rowHeight
            }
        }
    }
}
