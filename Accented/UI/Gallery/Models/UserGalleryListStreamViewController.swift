//
//  UserGalleryListStreamViewController.swift
//  Accented
//
//  Created by You, Tiangong on 9/8/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserGalleryListStreamViewController: InfiniteLoadingViewController<GalleryModel> {

    private var galleryCollection : GalleryCollectionModel
    
    init(galleryCollection : GalleryCollectionModel) {
        self.galleryCollection = galleryCollection
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func createViewModel() {
        viewModel = UserGalleryListViewModel(collection : galleryCollection, collectionView : collectionView)
    }
    
}
