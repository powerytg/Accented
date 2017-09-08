//
//  UserGalleryListViewModel.swift
//  Accented
//
//  View model for a user's gallery list
//
//  Created by You, Tiangong on 9/6/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserGalleryListViewModel: InfiniteLoadingViewModel<GalleryModel> {
    private let galleryRendererIdentifier = "gallery"
    
    override init(collection: CollectionModel<GalleryModel>, collectionView: UICollectionView) {
        super.init(collection: collection, collectionView: collectionView)
        
        // Register cell types
        let galleryCell = UINib(nibName: "GalleryListRenderer", bundle: nil)
        collectionView.register(galleryCell, forCellWithReuseIdentifier: galleryRendererIdentifier)
    }
    
    override func createCollectionViewLayout() {
        layout = UserGalleryListLayout()
        layout.collection = collection
    }

    override func loadPageAt(_ page : Int) {
        APIService.sharedInstance.getGalleries(userId: collection.modelId!, page: page, parameters: [String : String](), success: nil) { [weak self] (errorMessage) in
            self?.collectionFailedLoading(errorMessage)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentsViewModel.darkCellIdentifier, for: indexPath) as! GalleryListRenderer
        cell.gallery = collection.items[indexPath.item]
        cell.setNeedsLayout()
        return cell
    }
}
