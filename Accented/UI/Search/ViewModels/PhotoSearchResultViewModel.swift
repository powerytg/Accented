//
//  PhotoSearchResultViewModel.swift
//  Accented
//
//  Photo search result view model
//
//  Created by Tiangong You on 5/21/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class PhotoSearchResultViewModel: StreamViewModel, PhotoRendererDelegate {
    fileprivate let cardRendererReuseIdentifier = "renderer"
    
    required init(stream : StreamModel, collectionView : UICollectionView, flowLayoutDelegate: UICollectionViewDelegateFlowLayout) {
        super.init(stream: stream, collectionView: collectionView, flowLayoutDelegate: flowLayoutDelegate)
    }
    
    override func registerCellTypes() {
        collectionView.register(DefaultStreamPhotoCell.self, forCellWithReuseIdentifier: cardRendererReuseIdentifier)
    }
    
    override func createCollectionViewLayout() {
        layout = PhotoSearchResultLayout()
        layout.footerReferenceSize = CGSize(width: 50, height: 50)
    }
    
    override func createLayoutTemplateGenerator(_ maxWidth: CGFloat) -> StreamTemplateGenerator {
        return StreamCardLayoutGenerator(maxWidth: maxWidth)
    }
    
    // MARK: - Loading
    override func loadPageAt(_ page : Int) {
        let params = ["tags" : "1"]
        let searchModel = stream as! PhotoSearchStreamModel
        if let keyword = searchModel.keyword {
            APIService.sharedInstance.searchPhotos(keyword : keyword,
                                                   page: page,
                                                   sort : searchModel.sort,
                                                   parameters: params,
                                                   success: nil,
                                                   failure: { [weak self] (errorMessage) in
                self?.collectionFailedRefreshing(errorMessage)
                })
        } else if let tag = searchModel.tag {
            APIService.sharedInstance.searchPhotos(tag : tag,
                                                   page: page,
                                                   sort : searchModel.sort,
                                                   parameters: params,
                                                   success: nil,
                                                   failure: { [weak self] (errorMessage) in
                self?.collectionFailedRefreshing(errorMessage)
                })
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !collection.loaded {
            let loadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: initialLoadingRendererReuseIdentifier, for: indexPath)
            return loadingCell
        } else {
            let group = photoGroups[(indexPath as NSIndexPath).section]
            let photo = group[(indexPath as NSIndexPath).item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardRendererReuseIdentifier, for: indexPath) as! DefaultStreamPhotoCell
            cell.photo = photo
            cell.renderer.delegate = self
            cell.setNeedsLayout()
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let loadingView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: loadingFooterRendererReuseIdentifier, for: indexPath) as! DefaultStreamInlineLoadingCell

            // If the stream has more content, show the loading cell for the last section
            let totalSectionCount = self.numberOfSections(in: collectionView)
            if (indexPath as NSIndexPath).section == totalSectionCount - 1 && canLoadMore() {
                loadingView.viewModel = self
                
                // If there are no more items in the stream to load, show the ending status
                if stream.items.count >= stream.totalCount! {
                    loadingView.showEndingState()
                } else {
                    // Otherwise, always show the loading state, even if the previous attempt of loading failed. This is because we'll trigger loadNextPage() regardless of footer state
                    loadingView.showLoadingState()
                }
                
                self.loadingCell = loadingView
                return loadingView
            } else {
                // For any other sections, show a non-visible placeholder footer
                return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: invisiblePlaceholderFooterReuseIdentifier, for: indexPath)
            }
        }
        
        // Should not reach this line
        fatalError("Element type not supported!")
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if !collection.loaded {
            return 1
        } else {
            return photoGroups.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !collection.loaded {
            return 1
        } else {
            return photoGroups[section].count
        }
    }
    
    // MARK: - PhotoRendererDelegate
    
    func photoRendererDidReceiveTap(_ renderer: PhotoRenderer) {
        let navContext = DetailNavigationContext(selectedPhoto: renderer.photo!, photoCollection: collection.items, sourceImageView: renderer.imageView)
        NavigationService.sharedInstance.navigateToDetailPage(navContext)
    }
    
}
