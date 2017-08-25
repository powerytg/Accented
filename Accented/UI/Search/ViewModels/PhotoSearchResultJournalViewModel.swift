//
//  PhotoSearchResultJournalViewModel.swift
//  Accented
//
//  Photo search result view model in journal style
//
//  Created by Tiangong You on 5/21/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class PhotoSearchResultJournalViewModel: PhotoSearchResultViewModel {
    private let cardRendererReuseIdentifier = "renderer"
    
    override func registerCellTypes() {
        collectionView.register(JournalPhotoCell.self, forCellWithReuseIdentifier: cardRendererReuseIdentifier)
    }
    
    override func createCollectionViewLayout() {
        layout = PhotoSearchResultLayout()
        layout.footerReferenceSize = CGSize(width: 50, height: 50)
    }
    
    override func createLayoutTemplateGenerator(_ maxWidth: CGFloat) -> StreamTemplateGenerator {
        return StreamJournalLayoutGenerator(maxWidth: maxWidth)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !collection.loaded {
            let loadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: initialLoadingRendererReuseIdentifier, for: indexPath)
            return loadingCell
        } else {
            let group = photoGroups[(indexPath as NSIndexPath).section]
            let photo = group[(indexPath as NSIndexPath).item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardRendererReuseIdentifier, for: indexPath) as! JournalPhotoCell
            cell.photo = photo
            cell.photoView.delegate = self
            cell.setNeedsLayout()
            
            return cell
        }
    }
}
