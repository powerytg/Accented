//
//  DetailHeaderSectionView.swift
//  Accented
//
//  Created by Tiangong You on 8/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailHeaderSectionView: DetailSectionViewBase {

    private var avatarView = UIImageView()
    private var authorLabel = UILabel()

    // Fixed height
    private var sectionHeight : CGFloat = 140
    
    // Fixed avatar size
    private var avatarSize : CGFloat = 40
    
    // Margin right
    private var marginRight : CGFloat = 60
    
    override init(maxWidth: CGFloat) {
        super.init(maxWidth: maxWidth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initialize() {
        super.initialize()
        
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.contentMode = .ScaleAspectFit
        addSubview(avatarView)
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.textColor = UIColor.whiteColor()
        authorLabel.font = UIFont.systemFontOfSize(16)
        authorLabel.preferredMaxLayoutWidth = maxWidth - marginRight
        authorLabel.numberOfLines = 1
        authorLabel.lineBreakMode = .ByTruncatingMiddle
        addSubview(authorLabel)
        
        // Constraints
        avatarView.widthAnchor.constraintEqualToConstant(avatarSize).active = true
        avatarView.heightAnchor.constraintEqualToConstant(avatarSize).active = true
        avatarView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 15).active = true
        avatarView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        
        authorLabel.leadingAnchor.constraintEqualToAnchor(avatarView.trailingAnchor, constant: 15).active = true
        authorLabel.bottomAnchor.constraintEqualToAnchor(self.avatarView.bottomAnchor, constant: -6).active = true
    }
    
    override func photoModelDidChange() {
        guard photo != nil else { return }
        
        if let avatarUrl = preferredAvatarUrl() {
            avatarView.af_setImageWithURL(avatarUrl)
        }
        
        authorLabel.text = preferredAuthorName().uppercaseString
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarView.layer.shadowPath = UIBezierPath(rect: CGRectMake(0, 0, avatarSize, avatarSize)).CGPath
        avatarView.layer.shadowColor = UIColor.blackColor().CGColor
        avatarView.layer.shadowOpacity = 0.25
        avatarView.layer.shadowRadius = 3
        avatarView.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    // MARK: - Measurements
    
    override func estimatedHeight(width : CGFloat) -> CGFloat {
        return sectionHeight
    }
    
    // MARK: - Private
    
    private func preferredAvatarUrl() -> NSURL? {
        let user = photo!.user
        
        if let avatar = user.avatarUrls[.Default] {
            return NSURL(string: avatar)
        } else if let avatar = user.avatarUrls[.Large] {
            return NSURL(string: avatar)
        } else if let avatar = user.avatarUrls[.Small] {
            return NSURL(string: avatar)
        } else if let avatar = user.avatarUrls[.Tiny] {
            return NSURL(string: avatar)
        } else {
            return nil
        }
    }
    
    private func preferredAuthorName() -> String {
        let user = photo!.user

        if let name = user.fullName {
            return name
        } else if let name = user.firstName {
            return name
        } else  {
            return user.userName
        }
    }
    
}
