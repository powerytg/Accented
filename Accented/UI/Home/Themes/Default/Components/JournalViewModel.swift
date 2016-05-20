//
//  JournalViewModel.swift
//  Accented
//
//  Created by You, Tiangong on 5/19/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class JournalViewModel: StreamViewModel, StreamLayoutDelegate {

    private let headerReuseIdentifier = "header"
    private let cardRendererReuseIdentifier = "renderer"
    private let initialLoadingRendererReuseIdentifier = "initialLoading"
    private let loadingFooterRendererReuseIdentifier = "loadingFooter"
    
    // Header section, which includes the logo, the nav bar and the buttons
    private let headerSection = 0
    
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
        collectionView.registerClass(DefaultStreamPhotoCell.self, forCellWithReuseIdentifier: cardRendererReuseIdentifier)
        
        // Header cell
        let headerCellNib = UINib(nibName: "JournalHeaderTitleCell", bundle: nil)
        collectionView.registerNib(headerCellNib, forCellWithReuseIdentifier: headerReuseIdentifier)
        
        // Inline loading
        let loadingCellNib = UINib(nibName: "DefaultStreamInlineLoadingCell", bundle: nil)
        collectionView.registerNib(loadingCellNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: loadingFooterRendererReuseIdentifier)
        
        // Initial loading
        let initialLoadingCellNib = UINib(nibName: "DefaultStreamInitialLoadingCell", bundle: nil)
        collectionView.registerNib(initialLoadingCellNib, forCellWithReuseIdentifier: initialLoadingRendererReuseIdentifier)
    }
    
    override func createLayoutEngine() {
        layoutEngine = JournalStreamLayout()
        layoutEngine.delegate = self
        layoutEngine.headerReferenceSize = CGSizeMake(50, 50)
        layoutEngine.footerReferenceSize = CGSizeMake(50, 50)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.section == headerSection {
            // Stream headers
            if indexPath.item == 0 {
                let headerCell = collectionView.dequeueReusableCellWithReuseIdentifier(headerReuseIdentifier, forIndexPath: indexPath) as! JournalHeaderTitleCell
                headerCell.stream = stream
                headerCell.setNeedsLayout()
                return headerCell
            } else {
                fatalError("There is no header cells beyond index 0")
            }
        } else {
            if !stream.loaded {
                let loadingCell = collectionView.dequeueReusableCellWithReuseIdentifier(initialLoadingRendererReuseIdentifier, forIndexPath: indexPath)
                return loadingCell
            } else {
                let group = photoGroups[indexPath.section - photoStartSection]
                let photo = group[indexPath.item]
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cardRendererReuseIdentifier, forIndexPath: indexPath) as! DefaultStreamPhotoCell
                cell.photo = photo
                cell.setNeedsLayout()
                
                return cell
            }
        }
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if !stream.loaded {
            return photoStartSection + 1
        } else {
            return photoGroups.count + photoStartSection
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == headerSection {
            return 1
        } else {
            if !stream.loaded {
                return 1
            } else {
                return photoGroups[section - photoStartSection].count
            }
        }
    }
    
    // MARK: - Events
    
    override func streamFailedLoading(error: String) {
        super.streamFailedLoading(error)
        if let loadingView = self.loadingCell {
            loadingView.showRetryState()
        }
    }
    
    // MARK: - StreamLayoutDelegate
    
    func streamHeaderCompressionRatioDidChange(headerCompressionRatio: CGFloat) {
        // Ignore
    }

    // MARK: - Private
    
    private func canLoadMore() -> Bool {
        return stream.totalCount! > stream.photos.count
    }

}
