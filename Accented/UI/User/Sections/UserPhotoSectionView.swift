//
//  UserPhotoSectionView.swift
//  Accented
//
//  Created by Tiangong You on 8/23/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserPhotoSectionView: UserSectionViewBase {

    override var title: String? {
        return "LASTEST ARTWORK FROM " + user.userName.uppercased()
    }
    
    private let vGap : CGFloat = 20
    
    // Load more button
    private let loadMoreButton = PushButton(frame : CGRect.zero)
    
    // User stream
    private var userStream : UserStreamModel!
    
    // User's latest photo
    private var latestPhoto : PhotoModel? {
        if userStream.items.count == 0 {
            return nil
        } else {
            return userStream.items[0]
        }
    }
    
    // Image view for the latest photo
    private var photoRenderer : PhotoRenderer!
    
    // Photo renderer height
    private var photoRendererHeight : CGFloat = 0
    
    override func initialize() {
        super.initialize()

        // Get a copy of user photo stream
        userStream = StorageService.sharedInstance.getUserStream(userId: user.userId)
        
        // Create a photo renderer
        photoRenderer = PhotoRenderer()
        contentView.addSubview(photoRenderer)
        
        // Create a load-more button
        loadMoreButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        loadMoreButton.setTitle("More Photos From User", for: .normal)
        loadMoreButton.sizeToFit()
        contentView.addSubview(loadMoreButton)
        
        // Events
        loadMoreButton.addTarget(self, action: #selector(loadMoreButtonDidTap(_:)), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(userPhotosDidUpdate(_:)), name: StorageServiceEvents.streamDidUpdate, object: nil)
        
        // Load the galery list from user
        APIService.sharedInstance.getUserPhotos(userId: user.userId)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func loadMoreButtonDidTap(_ sender : NSObject) {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard latestPhoto != nil else { return }
        
        var nextY = contentTopPadding
        
        photoRenderer.photo = latestPhoto
        var f = photoRenderer.frame
        f.origin.x = contentLeftPadding
        f.origin.y = nextY
        f.size.width = contentView.bounds.size.width - contentLeftPadding - contentRightPadding
        f.size.height = photoRendererHeight
        photoRenderer.frame = f
        nextY += photoRendererHeight + vGap
        
        f = loadMoreButton.frame
        f.origin.x = contentLeftPadding
        f.origin.y = nextY
        loadMoreButton.frame = f
    }
    
    override func calculateContentHeight(maxWidth: CGFloat) -> CGFloat {
        if let latestPhoto = self.latestPhoto {
            let photoWidth = maxWidth - contentLeftPadding - contentRightPadding
            let photoAspectRatio = latestPhoto.height / latestPhoto.width
            photoRendererHeight = photoWidth * photoAspectRatio
            return photoRendererHeight + sectionTitleHeight + 50
        } else {
            return 0
        }
    }
    
    // MARK: - Events
    
    @objc private func userPhotosDidUpdate(_ notification : Notification) {
        let userId = notification.userInfo![StorageServiceEvents.streamId] as! String
        guard user.userId == userId else { return }
        
        // Get a copy of the updated comments
        self.userStream = StorageService.sharedInstance.getUserStream(userId: userId)
        invalidateSize()
    }
}
