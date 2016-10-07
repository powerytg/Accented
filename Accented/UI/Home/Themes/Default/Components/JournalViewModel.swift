//
//  JournalViewModel.swift
//  Accented
//
//  Created by You, Tiangong on 5/19/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class JournalViewModel: StreamViewModel, StreamLayoutDelegate, PhotoRendererDelegate {

    fileprivate let headerReuseIdentifier = "journalHeader"
    fileprivate let photoRendererReuseIdentifier = "journalPhotoRenderer"
    fileprivate let initialLoadingRendererReuseIdentifier = "journalTnitialLoading"
    fileprivate let loadingFooterRendererReuseIdentifier = "journalLoadingFooter"
    static let backdropDecorIdentifier = "journalBackdrop"
    static let bubbleDecorIdentifier = "journalBubble"
    
    // Header section, which includes the logo, the nav bar and the buttons
    fileprivate let headerSection = 0
    
    override var photoStartSection : Int {
        return 1
    }
    
    // Inline infinite loading cell
    var loadingCell : DefaultStreamInlineLoadingCell?
    
    required init(stream : StreamModel, collectionView : UICollectionView, flowLayoutDelegate: UICollectionViewDelegateFlowLayout) {
        super.init(stream: stream, collectionView: collectionView, flowLayoutDelegate: flowLayoutDelegate)
    }
    
    override func registerCellTypes() {
        // Photo renderer
        collectionView.register(JournalPhotoCell.self, forCellWithReuseIdentifier: photoRendererReuseIdentifier)
        
        // Header cell
        let headerCellNib = UINib(nibName: "JournalHeaderTitleCell", bundle: nil)
        collectionView.register(headerCellNib, forCellWithReuseIdentifier: headerReuseIdentifier)
        
        // Inline loading
        let loadingCellNib = UINib(nibName: "DefaultStreamInlineLoadingCell", bundle: nil)
        collectionView.register(loadingCellNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: loadingFooterRendererReuseIdentifier)
        
        // Initial loading
        let initialLoadingCellNib = UINib(nibName: "DefaultStreamInitialLoadingCell", bundle: nil)
        collectionView.register(initialLoadingCellNib, forCellWithReuseIdentifier: initialLoadingRendererReuseIdentifier)
    }
    
    override func createLayoutEngine() {
        layoutEngine = JournalStreamLayout()
        layoutEngine.delegate = self
        
        // Register backdrop as decoration class
        layoutEngine.register(JournalBackdropCell.self, forDecorationViewOfKind: JournalViewModel.backdropDecorIdentifier)
        layoutEngine.register(JournalBubbleDecoCell.self, forDecorationViewOfKind: JournalViewModel.bubbleDecorIdentifier)
    }
    
    override func createLayoutTemplateGenerator(_ maxWidth: CGFloat) -> StreamTemplateGenerator {
        return StreamJournalLayoutGenerator(maxWidth: maxWidth)
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath as NSIndexPath).section == headerSection {
            // Stream headers
            if (indexPath as NSIndexPath).item == 0 {
                let headerCell = collectionView.dequeueReusableCell(withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! JournalHeaderTitleCell
                headerCell.stream = stream
                headerCell.setNeedsLayout()
                return headerCell
            } else {
                fatalError("There is no header cells beyond index 0")
            }
        } else {
            if !stream.loaded {
                let loadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: initialLoadingRendererReuseIdentifier, for: indexPath)
                return loadingCell
            } else {
                // In the journal layout, each group only has 1 photo item
                let group = photoGroups[(indexPath as NSIndexPath).section - photoStartSection]
                let photo = group[(indexPath as NSIndexPath).item]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoRendererReuseIdentifier, for: indexPath) as! JournalPhotoCell
                cell.photo = photo
                cell.photoView.delegate = self
                cell.setNeedsLayout()
                
                return cell
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
    
    // MARK: - Events
    
    override func streamFailedLoading(_ error: String) {
        super.streamFailedLoading(error)
        if let loadingView = self.loadingCell {
            loadingView.showRetryState()
        }
    }
    
    // MARK: - StreamLayoutDelegate
    
    func streamHeaderCompressionRatioDidChange(_ compressionState : StreamCompressionState) {
        // Ignore
    }

    // MARK: - PhotoRendererDelegate
    
    func photoRendererDidReceiveTap(_ renderer: PhotoRenderer) {
        let navContext = DetailNavigationContext(selectedPhoto: renderer.photo!, photoCollection: stream.photos, sourceImageView: renderer.imageView)
        NavigationService.sharedInstance.navigateToDetailPage(navContext)
    }
    
    // MARK: - Private
    
    fileprivate func canLoadMore() -> Bool {
        return stream.totalCount! > stream.photos.count
    }

}
