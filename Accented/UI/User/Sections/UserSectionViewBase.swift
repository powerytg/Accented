//
//  UserSectionViewBase.swift
//  Accented
//
//  Base class of the sections in the about card in the user profile page
//
//  Created by Tiangong You on 5/29/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserSectionViewBase: UIView {
    
    // User model
    var user : UserModel
    
    // Section title
    var title : String? {
        return nil
    }
    
    var sectionTitleHeight : CGFloat = 45
    var sectionTitleLabelLeftPadding : CGFloat = 15
    var sectionTitleLabelTopPadding : CGFloat = 15
    var sectionTitleLabel = UILabel()
    let contentLeftPadding : CGFloat = 15
    let contentRightPadding : CGFloat = 15
    let contentTopPadding : CGFloat = 8
    let contentBottomPadding : CGFloat = 8
    
    // Content view
    var contentView : UIView!
    
    // Overall width and height
    var width : CGFloat = 0
    var height : CGFloat = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(user : UserModel) {
        self.user = user
        super.init(frame : CGRect.zero)
        
        initialize()
    }
    
    // Subclass could override this method to supply their own content views
    func createContentView() {
        contentView = UIView()
    }
    
    func initialize() {
        // Create content view and add it as child
        createContentView()
        addSubview(contentView)
        
        // Create a title view if specified
        if title != nil {
            addSubview(sectionTitleLabel)
            sectionTitleLabel.textColor = ThemeManager.sharedInstance.currentTheme.titleTextColor
            sectionTitleLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 14)
            sectionTitleLabel.text = title
            sectionTitleLabel.sizeToFit()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if width != bounds.size.width || height != bounds.size.height {
            // Invalidate measurings
            width = bounds.size.width
            height = calculateContentHeight(maxWidth: width)
        }
        
        if(title != nil) {
            // Title section
            var f = sectionTitleLabel.frame
            f.origin.x = sectionTitleLabelLeftPadding
            f.origin.y = sectionTitleLabelTopPadding
            sectionTitleLabel.frame = f
            
            // Content view
            f = contentView.frame
            f.size.width = width
            f.origin.y = sectionTitleHeight
            f.size.height = height - sectionTitleHeight
            contentView.frame = f
        } else {
            contentView.frame = self.bounds
        }
    }
    
    func calculateContentHeight(maxWidth : CGFloat) -> CGFloat {
        fatalError("Not implemented in base class")
    }
    
    func adjustTextClarity() {
        // Base class do nothing
    }
}
