//
//  UserSearchResultRenderer.swift
//  Accented
//
//  Renderer for user search result in the search result page
//
//  Created by Tiangong You on 5/22/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserSearchResultRenderer: UICollectionViewCell {

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    var user : UserModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = ThemeManager.sharedInstance.currentTheme.titleTextColor
        subLabel.textColor = ThemeManager.sharedInstance.currentTheme.descTextColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didReceiveTap(_:)))
        contentView.addGestureRecognizer(tap)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = self.bounds
        
        if let user = self.user {
            if let avatarUrl = DetailUserUtils.preferredAvatarUrl(user) {
                avatarView.sd_setImage(with: avatarUrl)
            }
            
            titleLabel.text = user.fullName
            subLabel.text = "@\(user.userName!)"
        }
        
        let avatarSize = avatarView.bounds.size.width
        avatarView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: avatarSize, height: avatarSize)).cgPath
        avatarView.layer.shadowColor = UIColor.black.cgColor
        avatarView.layer.shadowOpacity = 0.25
        avatarView.layer.shadowRadius = 3
        avatarView.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    @objc private func didReceiveTap(_ tap : UITapGestureRecognizer) {
        NavigationService.sharedInstance.navigateToUserProfilePage(user: user!)
    }
}
