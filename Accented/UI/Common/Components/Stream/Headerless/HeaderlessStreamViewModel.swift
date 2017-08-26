//
//  HeaderlessStreamViewModel.swift
//  Accented
//
//  Generic photo stream without header, rendering photos in group style
//
//  Created by Tiangong You on 8/25/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class HeaderlessStreamViewModel: StreamViewModel, PhotoRendererDelegate {
    private let cardRendererReuseIdentifier = "renderer"
    
    required init(stream : StreamModel, collectionView : UICollectionView, flowLayoutDelegate: UICollectionViewDelegateFlowLayout) {
        super.init(stream: stream, collectionView: collectionView, flowLayoutDelegate: flowLayoutDelegate)
    }
    
    override func registerCellTypes() {
        collectionView.register(DefaultStreamPhotoCell.self, forCellWithReuseIdentifier: cardRendererReuseIdentifier)
    }
    
    override func createCollectionViewLayout() {
        layout = HeaderlessStreamLayout()
        layout.footerReferenceSize = CGSize(width: 50, height: 50)
    }
    
    override func createLayoutTemplateGenerator(_ maxWidth: CGFloat) -> StreamTemplateGenerator {
        return PhotoGroupTemplateGenarator(maxWidth: maxWidth)
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
        let navContext = DetailNavigationContext(selectedPhoto: renderer.photo!, sourceImageView: renderer.imageView)
        NavigationService.sharedInstance.navigateToDetailPage(navContext)
    }

}
