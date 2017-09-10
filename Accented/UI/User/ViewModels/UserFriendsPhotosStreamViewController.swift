//
//  UserFriendsPhotosStreamViewController.swift
//  Accented
//
//  Created by Tiangong You on 9/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserFriendsPhotosStreamViewController: StreamViewController {
    
    var user : UserModel
    var displayStyle : StreamDisplayStyle
    
    init(user : UserModel, stream: StreamModel, style : StreamDisplayStyle) {
        self.displayStyle = style
        self.user = user
        super.init(stream)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createViewModel() {
        if displayStyle == .group {
            viewModel = UserFriendsStreamViewModel(user : user, stream: stream, collectionView: collectionView, flowLayoutDelegate: self)
        } else if displayStyle == .card {
            viewModel = UserFriendsStreamCardViewModel(user : user, stream: stream, collectionView: collectionView, flowLayoutDelegate: self)
        }
    }
    
    override func streamDidUpdate(_ notification : Notification) -> Void {
        let streamId = notification.userInfo![StorageServiceEvents.streamId] as! String
        let page = notification.userInfo![StorageServiceEvents.page] as! Int
        guard streamId == stream.streamId else { return }
        
        // Get a new copy of the stream
        let friendsModel = stream as! UserFriendsStreamModel
        stream = StorageService.sharedInstance.getUserFriendsStream(userId: friendsModel.userId)
        
        if let vm = streamViewModel {
            vm.collecitonDidUpdate(collection: stream, page: page)
        }
    }
}
