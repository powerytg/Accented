//
//  DetailSectionViewBase.swift
//  Accented
//
//  Created by You, Tiangong on 7/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailSectionViewBase: UIView, DetailEntranceAnimation, CardAnimation {

    // Photo model
    var photoModel : PhotoModel?
    var photo : PhotoModel? {
        get {
            return photoModel
        }
        
        set(value) {
            if photoModel != value {
                photoModel = value
                photoModelDidChange()
            }
        }
    }
    
    // Max width for the section
    var maxWidth : CGFloat

    // Section title
    var title : String? {
        return nil
    }
    
    var sectionTitleHeight : CGFloat = 45
    var sectionTitleLabelLeftMargin : CGFloat = 15
    var sectionTitleLabelTopMargin : CGFloat = 15
    var sectionTitleLabel = UILabel()
    
    // Content view
    var contentView = UIView()
    
    // Common fonts and colors
    let descFont = UIFont(name: "AvenirNextCondensed-Regular", size: 18)
    let descColor = UIColor(red: 152 / 255.0, green: 152 / 255.0, blue: 152 / 255.0, alpha: 1)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(maxWidth : CGFloat) {
        self.maxWidth = maxWidth
        super.init(frame : CGRectZero)
        
        initialize()
    }
    
    func initialize() {
        self.clipsToBounds = false
        
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.clipsToBounds = false
        
        // Create a title view if specified
        if title != nil {
            addSubview(sectionTitleLabel)
            sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            sectionTitleLabel.textColor = ThemeManager.sharedInstance.currentTheme.titleTextColor
            sectionTitleLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 14)
            sectionTitleLabel.text = title
            
            sectionTitleLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: sectionTitleLabelTopMargin).active = true
            sectionTitleLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: sectionTitleLabelLeftMargin).active = true
            
            contentView.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: sectionTitleHeight).active = true
        } else {
            contentView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
            contentView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        }
        
        contentView.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        contentView.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
    }
    
    func photoModelDidChange() {
        // Not implemented in base class
    }
    
    // MARK: - Measurements
    
    func estimatedHeight(width : CGFloat) -> CGFloat {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Animations
    
    func entranceAnimationWillBegin() {
        // Not implemented in the base class
    }
    
    func performEntranceAnimation() {
        // Not implemented in the base class
    }
    
    func entranceAnimationDidFinish() {
        // Not implemented in the base class
    }
    
    func cardDidReceivePanGesture(translation: CGFloat, cardWidth: CGFloat) {
        // Not implemented in the base class
    }
    
    func cardSelectionDidChange(selected: Bool) {
        // Not implemented in the base class
    }
    
    func performCardTransitionAnimation() {
        // Not implemented in the base class
    }
}
