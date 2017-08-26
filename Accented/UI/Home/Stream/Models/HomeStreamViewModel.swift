//
//  HomeStreamViewModel.swift
//  Accented
//
//  Base view model for home stream
//
//  Created by Tiangong You on 8/25/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class HomeStreamViewModel: StreamViewModel, StreamLayoutDelegate, PhotoRendererDelegate  {
    var cardRendererReuseIdentifier : String {
        fatalError("Cell type not defined in base class")
    }
    
    // Header navigation cell
    let headerNavReuseIdentifier = "headerNav"
    
    // Header Buttons cell
    let headerButtonsReuseIdentifier = "headerButtons"
    
    // Header section, which includes the logo, the nav bar and the buttons
    let headerSection = 0
    
    override var photoStartSection : Int {
        return 1
    }
    
    // Navigation cell
    private var navCell : DefaultStreamHeaderNavCell?
    
    required init(stream : StreamModel, collectionView : UICollectionView, flowLayoutDelegate: UICollectionViewDelegateFlowLayout) {
        super.init(stream: stream, collectionView: collectionView, flowLayoutDelegate: flowLayoutDelegate)
    }
    
    override func registerCellTypes() {
        // Header navigation cell
        let headerNavCellNib = UINib(nibName: "DefaultStreamHeaderNavCell", bundle: nil)
        collectionView.register(headerNavCellNib, forCellWithReuseIdentifier: headerNavReuseIdentifier)
        
        // Header buttons cell
        let headerButtonsCellNib = UINib(nibName: "DefaultStreamButtonsCell", bundle: nil)
        collectionView.register(headerButtonsCellNib, forCellWithReuseIdentifier: headerButtonsReuseIdentifier)
    }
    
    override func photoCellAtIndexPath(_ indexPath : IndexPath) -> UICollectionViewCell {
        let group = photoGroups[(indexPath as NSIndexPath).section - photoStartSection]
        let photo = group[(indexPath as NSIndexPath).item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardRendererReuseIdentifier, for: indexPath) as! StreamPhotoCellBaseCollectionViewCell
        cell.photo = photo
        cell.renderer.delegate = self
        cell.setNeedsLayout()
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath as NSIndexPath).section == headerSection {
            // Stream headers
            if (indexPath as NSIndexPath).item == 0 {
                navCell = collectionView.dequeueReusableCell(withReuseIdentifier: headerNavReuseIdentifier, for: indexPath) as? DefaultStreamHeaderNavCell
                let cardLayout = layout as! DefaultStreamLayout
                cardLayout.navBarStickyPosition = -navCell!.navBarDefaultPosition
                return navCell!
            } else if (indexPath as NSIndexPath).item == 1 {
                let buttonsCell = collectionView.dequeueReusableCell(withReuseIdentifier: headerButtonsReuseIdentifier, for: indexPath) as! DefaultStreamButtonsCell
                buttonsCell.stream = stream
                buttonsCell.setNeedsLayout()
                return buttonsCell
            } else {
                fatalError("There is no header cells beyond index 1")
            }
        } else {
            if !stream.loaded {
                let loadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: initialLoadingRendererReuseIdentifier, for: indexPath)
                return loadingCell
            } else {
                return photoCellAtIndexPath(indexPath)
            }
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
    
    // MARK: - StreamLayoutDelegate
    
    func streamHeaderCompressionRatioDidChange(_ headerCompressionRatio: CGFloat) {
        navCell?.compressionRatio = headerCompressionRatio
        navCell?.setNeedsLayout()
    }
    
    // MARK: - PhotoRendererDelegate
    
    func photoRendererDidReceiveTap(_ renderer: PhotoRenderer) {
        let navContext = DetailNavigationContext(selectedPhoto: renderer.photo!, sourceImageView: renderer.imageView)
        NavigationService.sharedInstance.navigateToDetailPage(navContext)
    }
}
