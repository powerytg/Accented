//
//  SingleHeaderStreamViewModel.swift
//  Accented
//
//  Created by Tiangong You on 8/25/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class SingleHeaderStreamViewModel: StreamViewModel, PhotoRendererDelegate {
    
    var cardRendererReuseIdentifier : String {
        return "renderer"
    }
    
    let streamHeaderReuseIdentifier = "streamHeader"
    
    // Section index for the headers
    private let headerSection = 0    
    
    var headerHeight : CGFloat {
        fatalError("Subclass must specify a header height")
    }
    
    required init(stream : StreamModel, collectionView : UICollectionView, flowLayoutDelegate: UICollectionViewDelegateFlowLayout) {
        super.init(stream: stream, collectionView: collectionView, flowLayoutDelegate: flowLayoutDelegate)
    }
    
    override var photoStartSection : Int {
        return 1
    }
    
    override func registerCellTypes() {
        collectionView.register(DefaultStreamPhotoCell.self, forCellWithReuseIdentifier: cardRendererReuseIdentifier)
        
        let streamHeaderNib = UINib(nibName: "DefaultSingleStreamHeaderCell", bundle: nil)
        collectionView.register(streamHeaderNib, forCellWithReuseIdentifier: streamHeaderReuseIdentifier)
    }
    
    override func createLayoutTemplateGenerator(_ maxWidth: CGFloat) -> StreamTemplateGenerator {
        return PhotoGroupTemplateGenarator(maxWidth: maxWidth)
    }

    override func createCollectionViewLayout() {
        layout = SingleHeaderStreamLayout(headerHeight: headerHeight)
        layout.footerReferenceSize = CGSize(width: 50, height: 50)
    }
    
    func streamHeader(_ indexPath : IndexPath) -> UICollectionViewCell {
        fatalError("Subclass must specify a stream header")
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
            let group = photoGroups[(indexPath as NSIndexPath).section - photoStartSection]
            let photo = group[(indexPath as NSIndexPath).item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardRendererReuseIdentifier, for: indexPath) as! StreamPhotoCellBaseCollectionViewCell
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

    // MARK: - PhotoRendererDelegate
    
    func photoRendererDidReceiveTap(_ renderer: PhotoRenderer) {
        let navContext = DetailNavigationContext(selectedPhoto: renderer.photo!, sourceImageView: renderer.imageView)
        NavigationService.sharedInstance.navigateToDetailPage(navContext)
    }
}
