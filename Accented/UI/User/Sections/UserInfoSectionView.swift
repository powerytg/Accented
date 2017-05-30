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
    fileprivate var infoEntries = [(String, String)]()
    
    // Renderers
    fileprivate var renderers = [UserInfoEntryView]()
    
    fileprivate let rendererHeight : CGFloat = 26
    
    override func createContentView() {
        super.createContentView()
        
        // Compile a list of info entries
        compileInfoEntries()
        
        // Create renderers
        createRenderers()
        
        // Calculate overall height
        height = rendererHeight * CGFloat(infoEntries.count)
    }

    fileprivate func compileInfoEntries() {
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
    
    fileprivate func createRenderers() {
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
    }
    
    override func adjustTextClarity() {
        for renderer in renderers {
            renderer.adjustTextClarity()
        }
    }
}
