//
//  DetailOverviewSectionView.swift
//  Accented
//
//  Created by You, Tiangong on 7/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailOverviewSectionView: DetailSectionViewBase {

    var photoView : UIImageView!
    var titleLabel : UILabel!
    
    private static let titleLabelTopMargin : CGFloat = 50
    private static let titleLabelLeftMargin : CGFloat = 30
    private static let titleLabelRightMargin : CGFloat = 70
    private static let photoViewTopMargin : CGFloat = 20
    private static let titleFont = UIFont(name: "HelveticaNeue-Thin", size: 42)
    
    private var calculatedPhotoHeight : CGFloat!
    
    override func initialize() {
        super.initialize()
        self.translatesAutoresizingMaskIntoConstraints = false;
        
        // Title label
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        titleLabel.font = DetailOverviewSectionView.titleFont
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.preferredMaxLayoutWidth = maxWidth - DetailOverviewSectionView.titleLabelLeftMargin - DetailOverviewSectionView.titleLabelRightMargin
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .ByWordWrapping
        addSubview(titleLabel)
        
        // Photo view
        photoView = UIImageView()
        photoView.contentMode = .ScaleAspectFill
        photoView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(photoView)

        // Constaints
        titleLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: DetailOverviewSectionView.titleLabelLeftMargin).active = true
        titleLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: DetailOverviewSectionView.titleLabelRightMargin).active = true
        titleLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: DetailOverviewSectionView.titleLabelTopMargin).active = true

        // Calculate the final destination frame for the photo view
        self.calculatedPhotoHeight = DetailOverviewSectionView.estimatedPhotoViewHeight(photo, width: maxWidth)
        let photoViewDestFrame = DetailOverviewSectionView.targetRectForPhotoView(photo)
        photoView.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: photoViewDestFrame.origin.y).active = true
        photoView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor).active = true
        photoView.widthAnchor.constraintEqualToConstant(maxWidth).active = true
        photoView.heightAnchor.constraintEqualToConstant(self.calculatedPhotoHeight).active = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.text = photo.title.uppercaseString;
        
        let preferredImageUrlString = photo.imageUrls[ImageSize.Large]!
        let imageUrl = NSURL(string: preferredImageUrlString)!
        photoView.af_setImageWithURL(imageUrl)
    }
    
    override func estimatedHeight(width: CGFloat) -> CGFloat {
        // Calculate title label
        let titleSize = NSString(string : photo.title).boundingRectWithSize(CGSizeMake(maxWidth, CGFloat.max),
                                                                            options: .UsesLineFragmentOrigin,
                                                                            attributes: [NSFontAttributeName: DetailOverviewSectionView.titleFont!],
                                                                            context: nil).size;
        
        return self.calculatedPhotoHeight + titleSize.height + DetailOverviewSectionView.titleLabelTopMargin + DetailOverviewSectionView.photoViewTopMargin;
    }
    
    private static func estimatedPhotoViewHeight(photo : PhotoModel, width : CGFloat) -> CGFloat {
        let photoAspectRatio = photo.height / photo.width
        return width * photoAspectRatio
    }
    
    static func targetRectForPhotoView(photo : PhotoModel) -> CGRect {
        let w = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let titleSize = NSString(string : photo.title).boundingRectWithSize(CGSizeMake(w, CGFloat.max),
                                                                            options: .UsesLineFragmentOrigin,
                                                                            attributes: [NSFontAttributeName: DetailOverviewSectionView.titleFont!],
                                                                            context: nil).size;
        let photoHeight = estimatedPhotoViewHeight(photo, width: w)
        let top = DetailOverviewSectionView.titleLabelTopMargin + titleSize.height + photoViewTopMargin
        
        return CGRectMake(0, top, w, photoHeight)
    }
    
    // MARK: - Animations
    
    override func entranceAnimationWillBegin() {
        super.entranceAnimationWillBegin()
        titleLabel.alpha = 0
        titleLabel.transform = CGAffineTransformMakeTranslation(0, -30)
        
        // Initially hide the photo view. We'll reveal it after the completion of the entrance animation
        photoView.alpha = 0
    }
    
    override func performEntranceAnimation() {
        super.performEntranceAnimation()
        
        UIView .addKeyframeWithRelativeStartTime(0, relativeDuration: 1.0, animations: { [weak self] in
            self?.titleLabel.alpha = 1
            self?.titleLabel.transform = CGAffineTransformIdentity
        })
    }
    
    override func entranceAnimationDidFinish() {
        super.entranceAnimationDidFinish()
        photoView.alpha = 1
    }
    
}
