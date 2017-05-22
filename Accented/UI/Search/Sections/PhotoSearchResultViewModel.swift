//
//  PhotoSearchResultViewModel.swift
//  Accented
//
//  Created by Tiangong You on 5/21/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class PhotoSearchResultViewModel: StreamViewModel, PhotoRendererDelegate {
    fileprivate let cardRendererReuseIdentifier = "renderer"
    fileprivate let initialLoadingRendererReuseIdentifier = "initialLoading"
    fileprivate let cardSectionHeaderRendererReuseIdentifier = "sectionHeader"
    fileprivate let cardSectionFooterRendererReuseIdentifier = "sectionFooter"
    fileprivate let loadingFooterRendererReuseIdentifier = "loadingFooter"
    
    override var photoStartSection : Int {
        return 0
    }
    
    // Inline infinite loading cell
    var loadingCell : DefaultStreamInlineLoadingCell?
    required init(stream : StreamModel, collectionView : UICollectionView, flowLayoutDelegate: UICollectionViewDelegateFlowLayout) {
        super.init(stream: stream, collectionView: collectionView, flowLayoutDelegate: flowLayoutDelegate)
    }
    
    override func registerCellTypes() {
        collectionView.register(DefaultStreamPhotoCell.self, forCellWithReuseIdentifier: cardRendererReuseIdentifier)
        
        // Section header
        let sectionHeaderCellNib = UINib(nibName: "DefaultStreamSectionHeaderCell", bundle: nil)
        collectionView.register(sectionHeaderCellNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cardSectionHeaderRendererReuseIdentifier)
        
        // Section footer
        let sectionFooterCellNib = UINib(nibName: "DefaultStreamSectionFooterCell", bundle: nil)
        collectionView.register(sectionFooterCellNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: cardSectionFooterRendererReuseIdentifier)
        
        // Inline loading
        let loadingCellNib = UINib(nibName: "DefaultStreamInlineLoadingCell", bundle: nil)
        collectionView.register(loadingCellNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: loadingFooterRendererReuseIdentifier)
        
        // Initial loading
        let initialLoadingCellNib = UINib(nibName: "DefaultStreamInitialLoadingCell", bundle: nil)
        collectionView.register(initialLoadingCellNib, forCellWithReuseIdentifier: initialLoadingRendererReuseIdentifier)
    }
    
    override func createLayoutEngine() {
        layoutEngine = PhotoSearchResultLayout()
        layoutEngine.headerReferenceSize = CGSize(width: 50, height: 50)
        layoutEngine.footerReferenceSize = CGSize(width: 50, height: 50)
    }
    
    override func createLayoutTemplateGenerator(_ maxWidth: CGFloat) -> StreamTemplateGenerator {
        return StreamCardLayoutGenerator(maxWidth: maxWidth)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !stream.loaded {
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        let group = photoGroups[(indexPath as NSIndexPath).section - photoStartSection]
        
        if kind == UICollectionElementKindSectionHeader {
            let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cardSectionHeaderRendererReuseIdentifier, for: indexPath) as! DefaultStreamSectionHeaderCell
            return sectionHeaderView
        } else if kind == UICollectionElementKindSectionFooter {
            // If the stream has more content, show the loading cell for the last section
            let totalSectionCount = self.numberOfSections(in: collectionView)
            if (indexPath as NSIndexPath).section == totalSectionCount - 1 && canLoadMore() {
                let loadingView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: loadingFooterRendererReuseIdentifier, for: indexPath) as! DefaultStreamInlineLoadingCell
                loadingView.streamViewModel = self
                
                // If there are no more items in the stream to load, show the ending status
                if stream.photos.count >= stream.totalCount! {
                    loadingView.showEndingState()
                } else {
                    // Otherwise, always show the loading state, even if the previous attempt of loading failed. This is because we'll trigger loadNextPage() regardless of footer state
                    loadingView.showLoadingState()
                }
                
                self.loadingCell = loadingView
                return loadingView
            } else {
                let sectionFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: cardSectionFooterRendererReuseIdentifier, for: indexPath) as! DefaultStreamSectionFooterCell
                sectionFooterView.photoGroup = group
                sectionFooterView.setNeedsLayout()
                return sectionFooterView
            }
        }
        
        return UICollectionViewCell()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if !stream.loaded {
            return photoStartSection + 1
        } else {
            return photoGroups.count + photoStartSection
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !stream.loaded {
            return 1
        } else {
            return photoGroups[section - photoStartSection].count
        }
    }
    
    // MARK: - PhotoRendererDelegate
    
    func photoRendererDidReceiveTap(_ renderer: PhotoRenderer) {
        let navContext = DetailNavigationContext(selectedPhoto: renderer.photo!, photoCollection: stream.photos, sourceImageView: renderer.imageView)
        NavigationService.sharedInstance.navigateToDetailPage(navContext)
    }
    
    // MARK: - Events
    
    override func streamFailedLoading(_ error: String) {
        super.streamFailedLoading(error)
        if let loadingView = self.loadingCell {
            loadingView.showRetryState()
        }
    }
    
    // MARK: - Private
    
    fileprivate func canLoadMore() -> Bool {
        return stream.totalCount! > stream.photos.count
    }
}
