//
//  UserHeaderSectionView.swift
//  Accented
//
//  Created by Tiangong You on 8/23/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserHeaderSectionView: UserSectionViewBase {
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
        authorLabel.text = TextUtils.preferredAuthorName(user).uppercased()
        authorLabel.sizeToFit()
        
        if let avatarUrl = DetailUserUtils.preferredAvatarUrl(user) {
            avatarView.sd_setImage(with: avatarUrl)
        }
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
        return UserHeaderSectionView.sectionHeight
    }
}
