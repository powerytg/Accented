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
    private let streamHeaderReuseIdentifier = "streamHeader"
    private let headerSection = 0
    private var user : UserModel
    
    init(user : UserModel, collection: CollectionModel<GalleryModel>, collectionView: UICollectionView) {
        self.user = user
        super.init(collection: collection, collectionView: collectionView)
        
        // Register cell types
        let galleryCell = UINib(nibName: "GalleryListRenderer", bundle: nil)
        collectionView.register(galleryCell, forCellWithReuseIdentifier: galleryRendererIdentifier)
        
        let streamHeaderNib = UINib(nibName: "DefaultSingleStreamHeaderCell", bundle: nil)
        collectionView.register(streamHeaderNib, forCellWithReuseIdentifier: streamHeaderReuseIdentifier)

        // Events
        NotificationCenter.default.addObserver(self, selector: #selector(galleryListDidUpdate(_:)), name: StorageServiceEvents.userGalleryListDidUpdate, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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

    @objc private func galleryListDidUpdate(_ notification : Notification) {
        let userId = notification.userInfo![StorageServiceEvents.userId] as! String
        let page = notification.userInfo![StorageServiceEvents.page] as! Int
        guard userId == collection.modelId else { return }
        
        // Get a new copy of the comment collection
        collection = StorageService.sharedInstance.getUserGalleries(userId: userId)
        updateCollectionView(page == 1)
        streamState.loading = false
        
        if page == 1 {
            streamState.refreshing = false
            delegate?.viewModelDidRefresh()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !collection.loaded {
            let loadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: initialLoadingRendererReuseIdentifier, for: indexPath)
            return loadingCell
        } else if indexPath.section == headerSection {
            if indexPath.item == 0 {
                return streamHeader(indexPath)
            } else {
                fatalError("There is no header cells beyond index 0")
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: galleryRendererIdentifier, for: indexPath) as! GalleryListRenderer
            cell.gallery = collection.items[indexPath.item]
            cell.setNeedsLayout()
            return cell
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == headerSection {
            return 2
        } else {
            if !collection.loaded {
                return 1
            } else {
                return collection.items.count
            }
        }
    }
    
    private func streamHeader(_ indexPath : IndexPath) -> UICollectionViewCell {
        let streamHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: streamHeaderReuseIdentifier, for: indexPath) as! DefaultSingleStreamHeaderCell
        let userName = TextUtils.preferredAuthorName(user).uppercased()
        streamHeaderCell.titleLabel.text = "\(userName)'S \nGALLERIES"
        
        if let galleryCount = user.galleryCount {
            if galleryCount == 0 {
                streamHeaderCell.subtitleLabel.text = "NO ITEMS"
            } else if galleryCount == 1 {
                streamHeaderCell.subtitleLabel.text = "1 ITEM"
            } else {
                streamHeaderCell.subtitleLabel.text = "\(galleryCount) ITEMS"
            }
        } else {
            streamHeaderCell.subtitleLabel.isHidden = true
        }
        
        streamHeaderCell.displayStyleButton.isHidden = true
        streamHeaderCell.orderButton.isHidden = true
        streamHeaderCell.orderLabel.isHidden = true
        return streamHeaderCell
    }

}
