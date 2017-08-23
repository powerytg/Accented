//
//  UserGallerySection.swift
//  Accented
//
//  Created by Tiangong You on 8/23/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserGallerySection: UserSectionViewBase {
    
    override var title: String? {
        return user.userName.uppercased() + "'S GALLERIES"
    }
    
    private var thumbnailSize : CGFloat!
    private let hGap : CGFloat = 12
    private let vGap : CGFloat = 20
    
    // Maximum number of comments pre-created
    private let maxRenderesOnScreen = 3
    
    // Gallery renderers
    private var renderers = [GalleryRenderer]()
    
    // Load more button
    private let loadMoreButton = PushButton(frame: CGRect.zero)
    
    // User gallery collection data mdoel
    private var galleryCollection : GalleryCollectionModel!
    
    override func initialize() {
        super.initialize()
        
        // Calculate a proper size for the thumbnails
        let maxWidth = UIScreen.main.bounds.width - contentLeftPadding - contentRightPadding
        let rendererCount = CGFloat(maxRenderesOnScreen)
        thumbnailSize = (maxWidth - (hGap * rendererCount - 1)) / rendererCount
        
        // Create a limited number of comment renderers ahead of time
        for _ in 1...maxRenderesOnScreen {
            let renderer = GalleryRenderer(frame : CGRect(x: 0, y: 0, width: thumbnailSize, height: thumbnailSize))
            contentView.addSubview(renderer)
            renderers.append(renderer)
            renderer.isHidden = true
        }
        
        // Create a load-more button
        loadMoreButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        loadMoreButton.setTitle("See More Galleries", for: .normal)
        loadMoreButton.sizeToFit()
        loadMoreButton.isHidden = true
        contentView.addSubview(loadMoreButton)
        
        // Events
        loadMoreButton.addTarget(self, action: #selector(loadMoreButtonDidTap(_:)), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(userGalleryListDidUpdate(_:)), name: StorageServiceEvents.userGalleryListDidUpdate, object: nil)
        
        // Load the galery list from user
        APIService.sharedInstance.getGalleries(userId: user.userId)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func loadMoreButtonDidTap(_ sender : NSObject) {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard galleryCollection != nil else { return }
        
        if galleryCollection.totalCount == 0 || galleryCollection.items.count == 0 {
            // Photo has no galleries or still being loaded
            loadMoreButton.isHidden = true
        } else {
            // Showing the first few gallery thumbnails
            loadMoreButton.isHidden = false
            
            var nextX : CGFloat = contentLeftPadding
            for (index, renderer) in renderers.enumerated() {
                if index < galleryCollection.items.count {
                    let gallery = galleryCollection.items[index]
                    renderer.frame = CGRect(x: nextX, y: contentTopPadding, width: thumbnailSize, height: thumbnailSize)
                    renderer.gallery = gallery
                    renderer.isHidden = false
                } else {
                    renderer.isHidden = true
                }
                
                nextX += thumbnailSize + hGap
            }
            
            var f = loadMoreButton.frame
            f.origin.x = contentLeftPadding
            f.origin.y = contentTopPadding + thumbnailSize + vGap
            loadMoreButton.frame = f
        }
    }
    
    override func calculateContentHeight(maxWidth: CGFloat) -> CGFloat {
        // Get a copy of the comments
        self.galleryCollection = StorageService.sharedInstance.getUserGalleries(userId: user.userId)
        
        if galleryCollection.totalCount == 0 || galleryCollection.items.count == 0 {
            return 0
        } else {
            return sectionTitleHeight + thumbnailSize + vGap + 40
        }
    }
    
    // MARK: - Events
    
    @objc private func userGalleryListDidUpdate(_ notification : Notification) {
        let userId = notification.userInfo![StorageServiceEvents.userId] as! String
        guard user.userId == userId else { return }
        
        // Get a copy of the updated comments
        self.galleryCollection = StorageService.sharedInstance.getUserGalleries(userId: userId)
        
        // Trigger an animated layout validation
        invalidateSize()
    }

}
