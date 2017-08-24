//
//  UserStreamViewModel.swift
//  Accented
//
//  User stream photos
//
//  Created by Tiangong You on 5/31/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserStreamViewModel : PhotoSearchResultViewModel{

    private let cardRendererReuseIdentifier = "renderer"
    
    // Section index for the headers
    private let headerSection = 0
    private let streamHeaderIdentifier = "streamHeader"
    private var streamHeaderCell : UserStreamHeaderCell?

    var user : UserModel
    
    required init(user : UserModel, stream : StreamModel, collectionView : UICollectionView, flowLayoutDelegate: UICollectionViewDelegateFlowLayout) {
        self.user = user
        super.init(stream: stream, collectionView: collectionView, flowLayoutDelegate: flowLayoutDelegate)
    }
    
    required init(stream: StreamModel, collectionView: UICollectionView, flowLayoutDelegate: UICollectionViewDelegateFlowLayout) {
        fatalError("init(stream:collectionView:flowLayoutDelegate:) has not been implemented")
    }
    
    override var photoStartSection : Int {
        return 1
    }
    
    override func registerCellTypes() {
        super.registerCellTypes()
        
        let streamHeaderNib = UINib(nibName: "UserStreamHeaderCell", bundle: nil)
        collectionView.register(streamHeaderNib, forCellWithReuseIdentifier: streamHeaderIdentifier)
    }
    
    override func createCollectionViewLayout() {
        layout = UserStreamLayout()
        layout.footerReferenceSize = CGSize(width: 50, height: 50)
    }

    override func loadPageAt(_ page : Int) {
        let params = ["tags" : "1"]
        let userStreamModel = stream as! UserStreamModel
        APIService.sharedInstance.getUserPhotos(userId: userStreamModel.userId, page: page, parameters: params, success: nil) { [weak self] (errorMessage) in
            self?.collectionFailedRefreshing(errorMessage)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == headerSection {
            if indexPath.item == 0 {
                streamHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: streamHeaderIdentifier, for: indexPath) as? UserStreamHeaderCell
                streamHeaderCell!.user = user
                return streamHeaderCell!
            } else {
                fatalError("There is no header cells beyond index 0")
            }
        } else if !collection.loaded {
            let loadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: initialLoadingRendererReuseIdentifier, for: indexPath)
            return loadingCell
        } else {
            let group = photoGroups[(indexPath as NSIndexPath).section - photoStartSection]
            let photo = group[(indexPath as NSIndexPath).item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardRendererReuseIdentifier, for: indexPath) as! DefaultStreamPhotoCell
            cell.photo = photo
            cell.renderer.delegate = self
            cell.setNeedsLayout()
            
            return cell
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if !stream.loaded {
            return photoStartSection + 1
        } else {
            return photoGroups.count + photoStartSection
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == headerSection {
            return 2
        } else {
            if !stream.loaded {
                return 1
            } else {
                return photoGroups[section - photoStartSection].count
            }
        }
    }
}
