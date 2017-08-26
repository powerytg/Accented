//
//  GatewayViewModel.swift
//  Accented
//
//  Created by Tiangong You on 5/2/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DefaultViewModel: HomeStreamViewModel {
    
    override var cardRendererReuseIdentifier : String {
        return "groupRenderer"
    }
    
    private let cardSectionHeaderRendererReuseIdentifier = "sectionHeader"
    private let cardSectionFooterRendererReuseIdentifier = "sectionFooter"
    
    override func registerCellTypes() {
        super.registerCellTypes()
        
        collectionView.register(DefaultStreamPhotoCell.self, forCellWithReuseIdentifier: cardRendererReuseIdentifier)
        
        // Section header
        let sectionHeaderCellNib = UINib(nibName: "DefaultStreamSectionHeaderCell", bundle: nil)
        collectionView.register(sectionHeaderCellNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cardSectionHeaderRendererReuseIdentifier)
        
        // Section footer
        let sectionFooterCellNib = UINib(nibName: "DefaultStreamSectionFooterCell", bundle: nil)
        collectionView.register(sectionFooterCellNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: cardSectionFooterRendererReuseIdentifier)
    }
    
    override func createCollectionViewLayout() {
        let defaultLayout = DefaultStreamLayout()
        defaultLayout.delegate = self
        layout = defaultLayout
        layout.headerReferenceSize = CGSize(width: 50, height: 50)
        layout.footerReferenceSize = CGSize(width: 50, height: 50)        
    }
    
    override func createLayoutTemplateGenerator(_ maxWidth: CGFloat) -> StreamTemplateGenerator {
        return PhotoGroupTemplateGenarator(maxWidth: maxWidth)
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (indexPath as NSIndexPath).section == headerSection {
            fatalError("Header section should not have any supplementary elements!")
        }
        
        if !stream.loaded {
            fatalError("Header section should not have any supplementary elements!")
        }
        
        let group = photoGroups[(indexPath as NSIndexPath).section - photoStartSection]
        
        if kind == UICollectionElementKindSectionHeader {
            let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cardSectionHeaderRendererReuseIdentifier, for: indexPath) as! DefaultStreamSectionHeaderCell
            return sectionHeaderView
        } else if kind == UICollectionElementKindSectionFooter {
            // If the stream has more content, show the loading cell for the last section
            let totalSectionCount = self.numberOfSections(in: collectionView)
            if (indexPath as NSIndexPath).section == totalSectionCount - 1 && canLoadMore() {
                let loadingView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: loadingFooterRendererReuseIdentifier, for: indexPath) as! DefaultStreamInlineLoadingCell
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
                let sectionFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: cardSectionFooterRendererReuseIdentifier, for: indexPath) as! DefaultStreamSectionFooterCell
                sectionFooterView.photoGroup = group
                sectionFooterView.setNeedsLayout()
                return sectionFooterView
            }
        }
        
        return UICollectionViewCell()
    }    
}
