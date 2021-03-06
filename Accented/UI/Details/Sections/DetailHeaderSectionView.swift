//
//  DetailHeaderSectionView.swift
//  Accented
//
//  Header section in the detail page contains user name and avatar
//
//  Created by Tiangong You on 8/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailHeaderSectionView: DetailSectionViewBase {

    private var avatarView = UIImageView()
    private var authorLabel = UILabel()

    // Fixed height
    static let sectionHeight : CGFloat = 120
    
    private let labelPaddingLeft : CGFloat = 120
    private let avatarSize : CGFloat = 40
    private let avatarPaddingTop : CGFloat = 26
    private let avatarPaddingRight : CGFloat = 15
    private let gap : CGFloat = 25
    
    override func initialize() {
        super.initialize()
        
        avatarView.contentMode = .scaleAspectFit
        contentView.addSubview(avatarView)
        
        authorLabel.textColor = ThemeManager.sharedInstance.currentTheme.titleTextColor
        authorLabel.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 17)!
        authorLabel.textAlignment = .right
        authorLabel.numberOfLines = 1
        authorLabel.lineBreakMode = .byTruncatingMiddle
        contentView.addSubview(authorLabel)
        authorLabel.text = TextUtils.preferredAuthorName(photo.user).uppercased()
        authorLabel.sizeToFit()
        
        if let avatarUrl = DetailUserUtils.preferredAvatarUrl(photo.user) {
            avatarView.sd_setImage(with: avatarUrl)
        }
        
        // Gestures
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnUserProfile(_:)))
        authorLabel.isUserInteractionEnabled = true
        authorLabel.addGestureRecognizer(tap)
        
        avatarView.isUserInteractionEnabled = true
        avatarView.addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var nextX : CGFloat = bounds.size.width - avatarPaddingRight
        var f = avatarView.frame
        f.size.width = avatarSize
        f.size.height = avatarSize
        f.origin.x = nextX - avatarSize
        f.origin.y = avatarPaddingTop
        avatarView.frame = f
        nextX -= (avatarSize + gap)

        f = authorLabel.frame
        f.origin.x = labelPaddingLeft
        f.origin.y = avatarPaddingTop
        f.size.width = nextX - f.origin.x
        authorLabel.frame = f

        // Avatar shadow
        avatarView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: avatarSize, height: avatarSize)).cgPath
        avatarView.layer.shadowColor = UIColor.black.cgColor
        avatarView.layer.shadowOpacity = 0.25
        avatarView.layer.shadowRadius = 3
        avatarView.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    // MARK: - Measurements
    
    override func calculateContentHeight(maxWidth: CGFloat) -> CGFloat {
        return DetailHeaderSectionView.sectionHeight
    }
    
    // MARK: - Animations
    
    override func entranceAnimationWillBegin() {
        authorLabel.alpha = 0
        avatarView.alpha = 0
        
        authorLabel.transform = CGAffineTransform(translationX: 30, y: 0)
        avatarView.transform = CGAffineTransform(translationX: 50, y: 0)
    }
    
    override func performEntranceAnimation() {
        UIView .addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 1, animations: { [weak self] in
            self?.authorLabel.alpha = 1
            self?.authorLabel.transform = CGAffineTransform.identity
            })
        
        UIView .addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 1, animations: { [weak self] in
            self?.avatarView.alpha = 1
            self?.avatarView.transform = CGAffineTransform.identity
            })
    }
    
    // MARK : - Events
    
    @objc private func didTapOnUserProfile(_ tap : UITapGestureRecognizer) {
        NavigationService.sharedInstance.navigateToUserProfilePage(user: photo.user)
    }
}
