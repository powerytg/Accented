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
    var authorLabel : UILabel!
    
    private static let titleLabelTopMargin : CGFloat = 50
    private static let titleLabelLeftMargin : CGFloat = 30
    private static let titleLabelRightMargin : CGFloat = 70
    private static let authorLabelTopMargin : CGFloat = 10
    private static let authorLabelLeftMargin : CGFloat = 30
    private static let authorLabelRightMargin : CGFloat = 120
    private static let photoViewTopMargin : CGFloat = 20
    private static let titleFont = UIFont(name: "HelveticaNeue-Thin", size: 46)
    private static let authorFont = UIFont(name: "HelveticaNeue-Medium", size: 18)
    
    private var calculatedPhotoHeight : CGFloat!
    
    override func initialize() {
        super.initialize()
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Title label
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = DetailOverviewSectionView.titleFont
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.preferredMaxLayoutWidth = maxWidth - DetailOverviewSectionView.titleLabelLeftMargin - DetailOverviewSectionView.titleLabelRightMargin
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .ByWordWrapping
        addSubview(titleLabel)
        
        // Author label
        authorLabel = UILabel()
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = DetailOverviewSectionView.authorFont
        authorLabel.textColor = UIColor.whiteColor()
        authorLabel.preferredMaxLayoutWidth = maxWidth - DetailOverviewSectionView.authorLabelLeftMargin - DetailOverviewSectionView.authorLabelRightMargin
        authorLabel.numberOfLines = 0
        authorLabel.lineBreakMode = .ByWordWrapping
        addSubview(authorLabel)
        
        // Photo view
        photoView = UIImageView()
        photoView.contentMode = .ScaleAspectFill
        photoView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(photoView)

        // Constaints
        titleLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: DetailOverviewSectionView.titleLabelLeftMargin).active = true
        titleLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: DetailOverviewSectionView.titleLabelRightMargin).active = true
        titleLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: DetailOverviewSectionView.titleLabelTopMargin).active = true
        
        authorLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: DetailOverviewSectionView.authorLabelLeftMargin).active = true
        authorLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: DetailOverviewSectionView.authorLabelRightMargin).active = true
        authorLabel.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor, constant: DetailOverviewSectionView.authorLabelTopMargin).active = true

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
        
        titleLabel.text = photo.title.uppercaseString
        authorLabel.text = "by " + photo.firstName
        
        let preferredImageUrlString = photo.imageUrls[ImageSize.Large]!
        let imageUrl = NSURL(string: preferredImageUrlString)!
        photoView.af_setImageWithURL(imageUrl)
    }
    
    override func estimatedHeight(width: CGFloat) -> CGFloat {
        // Calculate title and author labels
        let titleAndAuthorHeight = DetailOverviewSectionView.estimatedTitleAndAuthorLabelSize(photo)

        return titleAndAuthorHeight + self.calculatedPhotoHeight + DetailOverviewSectionView.photoViewTopMargin
    }
    
    private static func estimatedPhotoViewHeight(photo : PhotoModel, width : CGFloat) -> CGFloat {
        let photoAspectRatio = photo.height / photo.width
        return width * photoAspectRatio
    }
    
    private static func estimatedTitleAndAuthorLabelSize(photo : PhotoModel) -> CGFloat {
        let w = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let maxTitleWidth = w - DetailOverviewSectionView.titleLabelLeftMargin - DetailOverviewSectionView.titleLabelRightMargin
        let titleSize = NSString(string : photo.title).boundingRectWithSize(CGSizeMake(maxTitleWidth, CGFloat.max),
                                                                            options: .UsesLineFragmentOrigin,
                                                                            attributes: [NSFontAttributeName: DetailOverviewSectionView.titleFont!],
                                                                            context: nil).size
        
        let maxAuthorWidth = w - DetailOverviewSectionView.authorLabelLeftMargin - DetailOverviewSectionView.authorLabelRightMargin
        let authorSize = NSString(string : photo.firstName).boundingRectWithSize(CGSizeMake(maxAuthorWidth, CGFloat.max),
                                                                                 options: .UsesLineFragmentOrigin,
                                                                                 attributes: [NSFontAttributeName: DetailOverviewSectionView.authorFont!],
                                                                                 context: nil).size

        return titleSize.height + DetailOverviewSectionView.titleLabelTopMargin + DetailOverviewSectionView.authorLabelTopMargin + authorSize.height
    }
    
    static func targetRectForPhotoView(photo : PhotoModel) -> CGRect {
        let w = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let titleAndAuthorHeight = DetailOverviewSectionView.estimatedTitleAndAuthorLabelSize(photo)
        let photoHeight = estimatedPhotoViewHeight(photo, width: w)
        let top = titleAndAuthorHeight +  photoViewTopMargin
        
        return CGRectMake(0, top, w, photoHeight)
    }
    
    // MARK: - Animations
    
    override func entranceAnimationWillBegin() {
        super.entranceAnimationWillBegin()
        titleLabel.alpha = 0
        titleLabel.transform = CGAffineTransformMakeTranslation(80, 0)

        authorLabel.alpha = 0
        authorLabel.transform = CGAffineTransformMakeTranslation(50, 0)

        // Initially hide the photo view. We'll reveal it after the completion of the entrance animation
        photoView.alpha = 0
    }
    
    override func performEntranceAnimation() {
        super.performEntranceAnimation()
        
        UIView .addKeyframeWithRelativeStartTime(0, relativeDuration: 0.8, animations: { [weak self] in
            self?.titleLabel.alpha = 1
            self?.titleLabel.transform = CGAffineTransformIdentity
        })
        
        UIView .addKeyframeWithRelativeStartTime(0.5, relativeDuration: 1.0, animations: { [weak self] in
            self?.authorLabel.alpha = 1
            self?.authorLabel.transform = CGAffineTransformIdentity
        })
    }
    
    override func entranceAnimationDidFinish() {
        super.entranceAnimationDidFinish()
        photoView.alpha = 1
    }
    
}
