//
//  MainMenuHeaderSectionView.swift
//  Accented
//
//  Created by Tiangong You on 8/27/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class MainMenuHeaderSectionView: MainMenuSectionBase {
    
    private var avatarView = UIImageView()
    private var authorButton = UIButton()
    
    // Fixed height
    static let sectionHeight : CGFloat = 180
    
    private let labelPaddingLeft : CGFloat = 120
    private let avatarSize : CGFloat = 40
    private let avatarPaddingTop : CGFloat = 36
    private let avatarPaddingRight : CGFloat = 15
    private let gap : CGFloat = 25
    
    override func initialize() {
        super.initialize()
        
        avatarView.contentMode = .scaleAspectFit
        contentView.addSubview(avatarView)
        
        authorButton.contentEdgeInsets = UIEdgeInsetsMake(4, 8, 4, 8)
        authorButton.titleLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 17)!
        authorButton.contentHorizontalAlignment = .right
        contentView.addSubview(authorButton)
        
        if let user = StorageService.sharedInstance.currentUser {
            if let avatarUrl = DetailUserUtils.preferredAvatarUrl(user) {
                avatarView.sd_setImage(with: avatarUrl)
            }
            
            authorButton.setTitleColor(ThemeManager.sharedInstance.currentTheme.menuTitleColor, for: .normal)
            authorButton.setTitle(TextUtils.preferredAuthorName(user).uppercased(), for: .normal)
        } else {
            authorButton.setTitleColor(UIColor(red: 30 / 255.0, green: 128 / 255.0, blue: 243 / 255.0, alpha: 1.0), for: .normal)
            authorButton.setTitle("Sign In To 500px", for: .normal)
        }
        
        authorButton.sizeToFit()
        
        // Gestures
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnUserProfile(_:)))
        avatarView.isUserInteractionEnabled = true
        avatarView.addGestureRecognizer(tap)
        
        authorButton.addTarget(self, action: #selector(didTapOnUserProfile(_:)), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var nextX : CGFloat = bounds.size.width - avatarPaddingRight
        if StorageService.sharedInstance.currentUser != nil {
            var f = avatarView.frame
            f.size.width = avatarSize
            f.size.height = avatarSize
            f.origin.x = nextX - avatarSize
            f.origin.y = avatarPaddingTop
            avatarView.frame = f
            nextX -= (avatarSize + gap)
            
            f = authorButton.frame
            f.origin.x = labelPaddingLeft
            f.origin.y = avatarPaddingTop
            f.size.width = nextX - f.origin.x
            authorButton.frame = f

            // Avatar shadow
            avatarView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: avatarSize, height: avatarSize)).cgPath
            avatarView.layer.shadowColor = UIColor.black.cgColor
            avatarView.layer.shadowOpacity = 0.25
            avatarView.layer.shadowRadius = 3
            avatarView.layer.shadowOffset = CGSize(width: 0, height: 2)
        } else {
            var f = authorButton.frame
            f = authorButton.frame
            f.origin.x = labelPaddingLeft
            f.origin.y = avatarPaddingTop
            f.size.width = nextX - f.origin.x
            authorButton.frame = f
        }
    }
    
    // MARK: - Measurements
    
    override func calculateContentHeight(maxWidth: CGFloat) -> CGFloat {
        return 80
    }
    
    // MARK : - Events
    
    @objc private func didTapOnUserProfile(_ sender : AnyObject) {
        drawer?.dismiss(animated: true, completion: { 
            if let user = StorageService.sharedInstance.currentUser {
                NavigationService.sharedInstance.navigateToUserProfilePage(user: user)
            } else {
                NavigationService.sharedInstance.signout()
            }
        })
    }
}
