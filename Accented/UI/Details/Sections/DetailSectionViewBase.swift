//
//  DetailSectionViewBase.swift
//  Accented
//
//  Created by You, Tiangong on 7/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailSectionViewBase: UIView, DetailEntranceAnimation, CardAnimation {

    // Section id
    // Each of the child class must override this id in order to properly access the cache controller
    var sectionId : String {
        return "base"
    }
    
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
    
    // Shared cache controller
    var cacheController : DetailCacheController
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(maxWidth : CGFloat, cacheController : DetailCacheController) {
        self.maxWidth = maxWidth
        self.cacheController = cacheController
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
    
    func estimatedHeight(photo : PhotoModel?, width : CGFloat) -> CGFloat {
        guard photo != nil else { return 0 }
        
        // Retrieve the height from cache
        let cachedHeight = cacheController.getSectionMeasurement(self, photoId: photo!.photoId)
        
        // If there's no cached measurement, request the calculation
        if cachedHeight != nil {
            return cachedHeight!
        } else {
            let calculatedHeight = calculatedHeightForPhoto(photo!, width: width)
            cacheController.setSectionMeasurement(calculatedHeight, section: self, photoId: photo!.photoId)
            return calculatedHeight
        }
    }
    
    func calculatedHeightForPhoto(photo : PhotoModel, width : CGFloat) -> CGFloat {
        return 0
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
