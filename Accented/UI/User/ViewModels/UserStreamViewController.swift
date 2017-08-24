//
//  UserStreamViewController.swift
//  Accented
//
//  User stream controller
//
//  Created by Tiangong You on 5/31/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserStreamViewController: StreamViewController {
    
    var user : UserModel
    
    init(user : UserModel, stream: StreamModel) {
        self.user = user
        super.init(stream)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createViewModel() {
        viewModel = UserStreamViewModel(user : user, stream: stream, collectionView: collectionView, flowLayoutDelegate: self)
    }
    
    override func streamDidUpdate(_ notification : Notification) -> Void {
        let streamId = notification.userInfo![StorageServiceEvents.streamId] as! String
        let page = notification.userInfo![StorageServiceEvents.page] as! Int
        guard streamId == stream.streamId else { return }
        
        // Get a new copy of the stream
        let userModel = stream as! UserStreamModel
        stream = StorageService.sharedInstance.getUserStream(userId: userModel.userId)

        if let vm = streamViewModel {
            vm.collecitonDidUpdate(collection: stream, page: page)
        }
    }
}
