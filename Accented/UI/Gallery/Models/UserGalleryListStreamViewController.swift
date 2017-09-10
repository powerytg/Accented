//
//  UserGalleryListStreamViewController.swift
//  Accented
//
//  Created by You, Tiangong on 9/8/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserGalleryListStreamViewController: InfiniteLoadingViewController<GalleryModel> {
    private var user : UserModel
    private var galleryCollection : GalleryCollectionModel
    
    init(user : UserModel) {
        self.user = user
        self.galleryCollection = StorageService.sharedInstance.getUserGalleries(userId: user.userId)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load stream if necessary
        if let vm = viewModel {
            vm.collection = galleryCollection
            vm.loadIfNecessary()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func createViewModel() {
        viewModel = UserGalleryListViewModel(user : user, collection : galleryCollection, collectionView : collectionView)
    }
    
}
