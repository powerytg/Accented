//
//  GatewayViewModel.swift
//  Accented
//
//  Created by Tiangong You on 5/2/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class GatewayViewModel: StreamViewModel {
    
    // Renderers
    private let cardRendererReuseIdentifier = "card"
    private let cardHeaderRendererReuseIdentifier = "cardHeader"
    private let cardSectionHeaderRendererReuseIdentifier = "cardSectionHeader"
    private let cardSectionFooterRendererReuseIdentifier = "cardSectionFooter"
    private let loadingFooterRendererReuseIdentifier = "loadingFooter"
    
    // Cell for infinite loading
    var loadingCell : StreamLoadingCell?
    
    required init(stream : StreamModel, collectionView : UICollectionView, flowLayoutDelegate: UICollectionViewDelegateFlowLayout) {
        super.init(stream: stream, collectionView: collectionView, flowLayoutDelegate: flowLayoutDelegate)
    }
    
    override func registerCellTypes() {
        collectionView.registerClass(StreamPhotoCell.self, forCellWithReuseIdentifier: cardRendererReuseIdentifier)
        
        let headerCellNib = UINib(nibName: "StreamHeaderCell", bundle: nil)
        collectionView.registerNib(headerCellNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cardHeaderRendererReuseIdentifier)
        
        let sectionHeaderCellNib = UINib(nibName: "StreamSectionHeaderCell", bundle: nil)
        collectionView.registerNib(sectionHeaderCellNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cardSectionHeaderRendererReuseIdentifier)
        
        let sectionFooterCellNib = UINib(nibName: "StreamSectionFooterCell", bundle: nil)
        collectionView.registerNib(sectionFooterCellNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: cardSectionFooterRendererReuseIdentifier)
        
        let loadingCellNib = UINib(nibName: "StreamLoadingCell", bundle: nil)
        collectionView.registerNib(loadingCellNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: loadingFooterRendererReuseIdentifier)
    }
    
    override func createLayoutEngine() {
        layoutEngine = GatewayCardLayout()
        layoutEngine.headerReferenceSize = CGSizeMake(50, 50)
        layoutEngine.footerReferenceSize = CGSizeMake(50, 50)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let group = photoGroups[indexPath.section]
        let photo = group[indexPath.item]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cardRendererReuseIdentifier, forIndexPath: indexPath) as! StreamPhotoCell
        cell.photo = photo
        cell.setNeedsLayout()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let group = photoGroups[indexPath.section]
        
        if kind == UICollectionElementKindSectionHeader {
            if indexPath.section == 0 {
                let streamHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: cardHeaderRendererReuseIdentifier, forIndexPath: indexPath) as! StreamHeaderCell
                streamHeaderView.stream = stream
                streamHeaderView.setNeedsLayout()
                return streamHeaderView
            } else {
                let sectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: cardSectionHeaderRendererReuseIdentifier, forIndexPath: indexPath) as! StreamSectionHeaderCell
                return sectionHeaderView
            }
        } else if kind == UICollectionElementKindSectionFooter {
            // If the stream has more content, show the loading cell for the last section
            if indexPath.section == photoGroups.count - 1 && canLoadMore() {
                let loadingView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: loadingFooterRendererReuseIdentifier, forIndexPath: indexPath) as! StreamLoadingCell
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
                let sectionFooterView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: cardSectionFooterRendererReuseIdentifier, forIndexPath: indexPath) as! StreamSectionFooterCell
                sectionFooterView.photoGroup = group
                sectionFooterView.setNeedsLayout()
                return sectionFooterView
            }
        }
        
        return UICollectionViewCell()
    }
    
    // MARK: - Events
    
    override func streamFailedLoading(error: String) {
        super.streamFailedLoading(error)
        if let loadingView = self.loadingCell {
            loadingView.showRetryState()
        }
    }
    
    // MARK: - Private
    
    private func canLoadMore() -> Bool {
        return stream.totalCount! > stream.photos.count
    }
    
}
