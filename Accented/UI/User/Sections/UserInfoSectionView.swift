//
//  UserInfoSectionView.swift
//  Accented
//
//  Created by Tiangong You on 5/29/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserInfoSectionView: UserSectionViewBase {

    // Info key value pairs to be rendered on screen
    private var infoEntries = [(String, String)]()
    
    // Renderers
    private var renderers = [UserInfoEntryView]()
    private let rendererHeight : CGFloat = 26

    // Follow button
    private var followButton = PushButton()
    private let followButtonVPadding : CGFloat = 15
    
    override var title: String? {
        return "CONTACT"
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func initialize() {
        super.initialize()

        // Compile a list of info entries
        compileInfoEntries()
        
        // Create renderers
        createRenderers()
        
        // Create follow button
        initializeFollowButton()
        
        // Events
        NotificationCenter.default.addObserver(self, selector: #selector(userFollowingStateDidChange(_:)), name: StorageServiceEvents.userFollowingStateDidUpdate, object: nil)
    }
    
    private func initializeFollowButton() {
        followButton.contentEdgeInsets = UIEdgeInsetsMake(4, 8, 4, 8)
        followButton.setTitle(titleForFollowButton(), for: .normal)
        contentView.addSubview(followButton)
        followButton.addTarget(self, action: #selector(followButtonDidTap(_:)), for: .touchUpInside)
        followButton.sizeToFit()
        // Follow button is available for users other than the current user
        followButton.isHidden = !hasFollowButton()
    }
    
    private func compileInfoEntries() {
        // Full name
        if let fullName = user.fullName {
            infoEntries.append(("Full Name", fullName))
        }
        
        // User name
        infoEntries.append(("User Name", user.userName))
        
        // Member since
        if let registrationDate = user.registrationDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            let dateString = dateFormatter.string(from: registrationDate as Date)

            infoEntries.append(("Member Since", "\(dateString)"))
        }
        
        // Location
        if user.country != nil && user.city != nil {
            infoEntries.append(("Location", "\(user.city!), \(user.country!)"))
        } else if user.country != nil {
            infoEntries.append(("Country", user.country!))
        } else if user.city != nil {
            infoEntries.append(("City", user.city!))
        }
        
        // Follower count
        if let followerCount = user.followersCount {
            infoEntries.append(("Followers", "\(followerCount)"))
        }
        
        // Friend count
        if let friendCount = user.friendCount {
            infoEntries.append(("Friends", "\(friendCount)"))
        }
        
        // Affection
        if let affection = user.affection {
            infoEntries.append(("Affections", "\(affection)"))
        }
        
        // Photo count
        if let photoCount = user.photoCount {
            infoEntries.append(("Photos", "\(photoCount)"))
        }

        // Gallery count
        if let galleryCount = user.galleryCount {
            infoEntries.append(("Galleries", "\(galleryCount)"))
        }
    }
    
    private func createRenderers() {
        for entry in infoEntries {
            let renderer = UserInfoEntryView(entry)
            renderers.append(renderer)
            contentView.addSubview(renderer)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var nextY : CGFloat = contentTopPadding
        for renderer in renderers {
            var f = renderer.frame
            f.origin.x = contentLeftPadding
            f.origin.y = nextY
            f.size.width = width
            f.size.height = rendererHeight
            renderer.frame = f
            
            nextY += f.size.height
        }
        
        var f = followButton.frame
        f.origin.x = contentLeftPadding
        f.origin.y = nextY + followButtonVPadding
        followButton.frame = f
    }
    
    override func calculateContentHeight(maxWidth: CGFloat) -> CGFloat {
        var infoSize = rendererHeight * CGFloat(infoEntries.count) + sectionTitleHeight
        if hasFollowButton() {
            infoSize += followButton.frame.height + followButtonVPadding
        }
        
        return infoSize
    }
    
    override func adjustTextClarity() {
        for renderer in renderers {
            renderer.adjustTextClarity()
        }
    }
    
    func invalidate() {
        followButton.removeFromSuperview()
        
        infoEntries.removeAll()
        for renderer in renderers {
            renderer.removeFromSuperview()
        }
        
        renderers.removeAll()

        compileInfoEntries()
        createRenderers()
        initializeFollowButton()
        invalidateSize()
    }
    
    private func titleForFollowButton() -> String? {
        if let following = user.following {
            if following == true {
                return "REMOVE FROM FRIENDS"
            } else {
                return "ADD TO FRIENDS"
            }
        } else {
            return nil
        }
    }
    
    private func hasFollowButton() -> Bool {
        if let currentUser = StorageService.sharedInstance.currentUser {
            if currentUser.userId == user.userId {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    @objc private func followButtonDidTap(_ sender : AnyObject) {
        followButton.alpha = 0.5
        followButton.isUserInteractionEnabled = false
        
        if user.following == true {
            APIService.sharedInstance.unfollowUser(userId: user.userId, success: nil, failure: { [weak self] (errorMessage) in
                self?.followButton.alpha = 1
                self?.followButton.isUserInteractionEnabled = true
            })
        } else {
            APIService.sharedInstance.followUser(userId: user.userId, success: nil, failure: { [weak self] (errorMessage) in
                self?.followButton.alpha = 1
                self?.followButton.isUserInteractionEnabled = true
            })
        }
    }
    
    @objc private func userFollowingStateDidChange(_ notification : Notification) {
        let updatedUser = notification.userInfo![StorageServiceEvents.user] as! UserModel
        guard user.userId == updatedUser.userId else { return }
        
        user.following = updatedUser.following
        
        followButton.alpha = 1
        followButton.isUserInteractionEnabled = true
        followButton.setTitle(titleForFollowButton(), for: .normal)
        followButton.sizeToFit()
    }
}
