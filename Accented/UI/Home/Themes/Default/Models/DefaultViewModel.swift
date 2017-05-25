//
//  GatewayViewModel.swift
//  Accented
//
//  Created by Tiangong You on 5/2/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DefaultViewModel: StreamViewModel, StreamLayoutDelegate, PhotoRendererDelegate {
    
    // Header navigation cell
    fileprivate let headerNavReuseIdentifier = "headerNav"

    // Header Buttons cell
    fileprivate let headerButtonsReuseIdentifier = "headerButtons"

    fileprivate let cardRendererReuseIdentifier = "renderer"
    fileprivate let cardSectionHeaderRendererReuseIdentifier = "sectionHeader"
    fileprivate let cardSectionFooterRendererReuseIdentifier = "sectionFooter"
    
    // Header section, which includes the logo, the nav bar and the buttons
    fileprivate let headerSection = 0
    
    override var photoStartSection : Int {
        return 1
    }

    // Navigation cell
    fileprivate var navCell : DefaultStreamHeaderNavCell?
    
    required init(stream : StreamModel, collectionView : UICollectionView, flowLayoutDelegate: UICollectionViewDelegateFlowLayout) {
        super.init(stream: stream, collectionView: collectionView, flowLayoutDelegate: flowLayoutDelegate)
    }
    
    override func registerCellTypes() {
        collectionView.register(DefaultStreamPhotoCell.self, forCellWithReuseIdentifier: cardRendererReuseIdentifier)
        
        // Header navigation cell
        let headerNavCellNib = UINib(nibName: "DefaultStreamHeaderNavCell", bundle: nil)
        collectionView.register(headerNavCellNib, forCellWithReuseIdentifier: headerNavReuseIdentifier)

        // Header buttons cell
        let headerButtonsCellNib = UINib(nibName: "DefaultStreamButtonsCell", bundle: nil)
        collectionView.register(headerButtonsCellNib, forCellWithReuseIdentifier: headerButtonsReuseIdentifier)
        
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
        return StreamCardLayoutGenerator(maxWidth: maxWidth)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
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
                let group = photoGroups[(indexPath as NSIndexPath).section - photoStartSection]
                let photo = group[(indexPath as NSIndexPath).item]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardRendererReuseIdentifier, for: indexPath) as! DefaultStreamPhotoCell
                cell.photo = photo
                cell.renderer.delegate = self
                cell.setNeedsLayout()
                
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
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
        let navContext = DetailNavigationContext(selectedPhoto: renderer.photo!, photoCollection: stream.items, sourceImageView: renderer.imageView)
        NavigationService.sharedInstance.navigateToDetailPage(navContext)
    }
}
