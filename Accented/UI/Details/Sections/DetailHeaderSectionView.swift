//
//  DetailHeaderSectionView.swift
//  Accented
//
//  Created by Tiangong You on 8/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailHeaderSectionView: DetailSectionViewBase {

    override var sectionId: String {
        return "header"
    }

    fileprivate var avatarView = UIImageView()
    fileprivate var authorLabel = UILabel()

    // Fixed height
    var sectionHeight : CGFloat = 140
    
    // Fixed avatar size
    fileprivate var avatarSize : CGFloat = 30
    
    // Margin right
    fileprivate var marginRight : CGFloat = 60
    
    override func initialize() {
        super.initialize()
        
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.contentMode = .scaleAspectFit
        contentView.addSubview(avatarView)
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.textColor = UIColor.white
        authorLabel.font = UIFont.systemFont(ofSize: 16)
        authorLabel.textAlignment = .right
        authorLabel.preferredMaxLayoutWidth = maxWidth - marginRight
        authorLabel.numberOfLines = 1
        authorLabel.lineBreakMode = .byTruncatingMiddle
        contentView.addSubview(authorLabel)
        
        // Constraints
        authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2).isActive = true
        authorLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 30).isActive = true

        avatarView.widthAnchor.constraint(equalToConstant: avatarSize).isActive = true
        avatarView.heightAnchor.constraint(equalToConstant: avatarSize).isActive = true
        avatarView.trailingAnchor.constraint(equalTo: self.authorLabel.trailingAnchor, constant: 0).isActive = true
        avatarView.topAnchor.constraint(equalTo: self.authorLabel.bottomAnchor, constant: 6).isActive = true

    }
    
    override func photoModelDidChange() {
        guard photo != nil else { return }        
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard photo != nil else { return }

        // Author
        if let avatarUrl = DetailUserUtils.preferredAvatarUrl(photo!.user) {
            avatarView.sd_setImage(with: avatarUrl)
        }
        
        authorLabel.text = TextUtils.preferredAuthorName(photo!.user).uppercased()

        // Avatar
        avatarView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: avatarSize, height: avatarSize)).cgPath
        avatarView.layer.shadowColor = UIColor.black.cgColor
        avatarView.layer.shadowOpacity = 0.25
        avatarView.layer.shadowRadius = 3
        avatarView.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    // MARK: - Measurements
    
    override func calculatedHeightForPhoto(_ photo: PhotoModel, width: CGFloat) -> CGFloat {
        return sectionHeight
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
    
}
