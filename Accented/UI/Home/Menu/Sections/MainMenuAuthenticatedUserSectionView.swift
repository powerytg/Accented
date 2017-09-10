//
//  MainMenuAuthenticatedUserSectionView.swift
//  Accented
//
//  Main menu section for authenticated user
//
//  Created by Tiangong You on 8/27/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class MainMenuAuthenticatedUserSectionView: MainMenuSectionBase {
    
    private let rowHeight : CGFloat = 32
    private let paddingTop : CGFloat = 32
    private let separatorHeight : CGFloat = 16
    
    let signedInOptions = [MainMenuItem(action : .Search, text: "Search", image : UIImage(named: "SearchButtonMainMenu")),
                       MenuSeparator(),
                       MainMenuItem(action:.MyPhotos, text: "My Photos"),
                       MainMenuItem(action:.MyGalleries, text: "My Galleries"),
                       MainMenuItem(action:.MyProfile, text: "My Profile"),
                       MenuSeparator(),
                       MainMenuItem(action:.MyFriends, text: "My Friends"),
                       MainMenuItem(action:.FriendsPhotos, text: "My Friends' Photos"),
                       MenuSeparator(),
                       MainMenuItem(action:.PearlCam, text: "Pearl Cam"),
                       MenuSeparator(),
                       MainMenuItem(action:.SignOut, text: "Sign Out")]

    let signedOutOptions = [MainMenuItem(action : .Search, text: "Search", image : UIImage(named: "SearchButtonMainMenu")),
                           MenuSeparator(),
                           MainMenuItem(action:.PopularPhotos, text: "Popular Photos"),
                           MainMenuItem(action:.FreshPhotos, text: "Fresh"),
                           MainMenuItem(action:.UpcomingPhotos, text: "Upcoming"),
                           MainMenuItem(action:.EditorsChoice, text: "Editors' Choice"),
                           MenuSeparator(),
                           MainMenuItem(action:.PearlCam, text: "Pearl Cam"),
                           MenuSeparator(),
                           MainMenuItem(action:.SignIn, text: "Sign In")]

    private var renderers = [MainMenuItemRenderer]()
    private var currentMenu : [MenuItem]!
    
    override func initialize() {
        super.initialize()
        
        if StorageService.sharedInstance.currentUser != nil {
            currentMenu = signedInOptions
        } else {
            currentMenu = signedOutOptions
        }
        
        for item in currentMenu {
            let renderer = MainMenuItemRenderer(item)
            contentView.addSubview(renderer)
            renderers.append(renderer)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(menuItemDidReceiveTap(_:)))
            renderer.addGestureRecognizer(tap)
        }
    }
    
    override func calculateContentHeight(maxWidth: CGFloat) -> CGFloat {
        var totalHeight : CGFloat = 0
        for item in currentMenu {
            if item is MenuSeparator {
                totalHeight += separatorHeight
            } else {
                totalHeight += rowHeight
            }
        }
        
        return totalHeight + paddingTop
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        var nextY : CGFloat = paddingTop
        for renderer in renderers {
            var f = renderer.frame
            f.origin.x = contentLeftPadding
            f.origin.y = nextY
            f.size.width = contentView.bounds.width - contentLeftPadding - contentRightPadding

            if renderer.menuItem is MenuSeparator {
                f.size.height = separatorHeight
            } else {
                f.size.height = rowHeight
            }
            
            renderer.frame = f
            
            if renderer.menuItem is MenuSeparator {
                nextY += separatorHeight
            } else {
                nextY += rowHeight
            }
        }
    }
    
    @objc private func menuItemDidReceiveTap(_ tap : UITapGestureRecognizer) {
        guard tap.view != nil else { return }
        guard tap.view! is MainMenuItemRenderer else { return }
        
        let renderer = tap.view! as! MainMenuItemRenderer
        guard renderer.menuItem is MainMenuItem else { return }

        didSelectMenuItem(renderer.menuItem as! MainMenuItem)
    }
    
    private func didSelectMenuItem(_ item : MainMenuItem) {
        switch item.action {
        case .SignIn:
            drawer?.dismiss(animated: false, completion: nil)
            NavigationService.sharedInstance.signout()
        case .SignOut:
            drawer?.dismiss(animated: false, completion: nil)
            NavigationService.sharedInstance.signout()            
        case .PopularPhotos:
            switchStream(.Popular)
            drawer?.dismiss(animated: true, completion: nil)
        case .FreshPhotos:
            switchStream(.FreshToday)
            drawer?.dismiss(animated: true, completion: nil)
        case .UpcomingPhotos:
            switchStream(.Upcoming)
            drawer?.dismiss(animated: true, completion: nil)
        case .EditorsChoice:
            switchStream(.Editors)
            drawer?.dismiss(animated: true, completion: nil)
        case .PearlCam:
            drawer?.dismiss(animated: true, completion: { 
                NavigationService.sharedInstance.navigateToCamera()
            })
        case .Search:
            drawer?.dismiss(animated: true, completion: {
                if let topVC = NavigationService.sharedInstance.topViewController() {
                    NavigationService.sharedInstance.navigateToSearch(from: topVC)
                }
            })
        case .MyProfile:
            drawer?.dismiss(animated: true, completion: {
                if let currentUser = StorageService.sharedInstance.currentUser {
                    NavigationService.sharedInstance.navigateToUserProfilePage(user: currentUser)
                }
            })
        case .MyGalleries:
            drawer?.dismiss(animated: true, completion: {
                if let currentUser = StorageService.sharedInstance.currentUser {
                    NavigationService.sharedInstance.navigateToUserGalleryListPage(user: currentUser)
                }
            })
        case .MyPhotos:
            drawer?.dismiss(animated: true, completion: {
                if let currentUser = StorageService.sharedInstance.currentUser {
                    NavigationService.sharedInstance.navigateToUserStreamPage(user: currentUser)
                }
            })
        case .MyFriends:
            break
        case .FriendsPhotos:
            break
        }
    }
        
    private func switchStream(_ streamType: StreamType) {
        let userInfo = [StreamEvents.selectedStreamType : streamType.rawValue]
        NotificationCenter.default.post(name: StreamEvents.streamSelectionWillChange, object: nil, userInfo: userInfo)
    }
}
