//
//  DetailSectionViewBase.swift
//  Accented
//
//  Created by You, Tiangong on 7/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

// Detail section view event delegate
protocol DetailSectionViewDelegate : NSObjectProtocol {
    // Section view will change its height
    func sectionViewMeasurementWillChange(_ section : DetailSectionViewBase)
}

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
    var contentView : UIView!
    
    // Common fonts and colors
    let descFont = UIFont(name: "AvenirNextCondensed-Regular", size: 18)
    let descColor = UIColor(red: 152 / 255.0, green: 152 / 255.0, blue: 152 / 255.0, alpha: 1)
    
    // Shared cache controller
    var cacheController : DetailCacheController
    
    // Event delegate
    weak var delegate : DetailSectionViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(maxWidth : CGFloat, cacheController : DetailCacheController) {
        self.maxWidth = maxWidth
        self.cacheController = cacheController
        super.init(frame : CGRect.zero)
        
        initialize()
    }
    
    // Subclass could override this method to supply their own content views
    func createContentView() {
        contentView = UIView()
    }
    
    func initialize() {
        self.clipsToBounds = false
        
        // Create content view and add it as child
        createContentView()
        addSubview(contentView)
        contentView.clipsToBounds = false
        
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

        if(title != nil) {
            // Title section
            var f = sectionTitleLabel.frame
            f.origin.x = sectionTitleLabelLeftMargin
            f.origin.y = sectionTitleLabelTopMargin
            sectionTitleLabel.frame = f
            
            // Content view
            f = contentView.frame
            f.size.width = self.bounds.size.width
            f.origin.y = sectionTitleHeight
            f.size.height = self.bounds.size.height - sectionTitleHeight
            contentView.frame = f
        } else {
            contentView.frame = self.bounds
        }
    }
    
    func photoModelDidChange() {
        // Not implemented in base class
    }
    
    // MARK: - Measurements
    
    func estimatedHeight(_ photo : PhotoModel?, width : CGFloat) -> CGFloat {
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
    
    func calculatedHeightForPhoto(_ photo : PhotoModel, width : CGFloat) -> CGFloat {
        return 0
    }
    
    // Notify the event delegate that the section view will change its height
    func invalidateMeasurements() {
        delegate?.sectionViewMeasurementWillChange(self)
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
    
    func cardDidReceivePanGesture(_ translation: CGFloat, cardWidth: CGFloat) {
        // Not implemented in the base class
    }
    
    func cardSelectionDidChange(_ selected: Bool) {
        // Not implemented in the base class
    }
    
    func performCardTransitionAnimation() {
        // Not implemented in the base class
    }
}
