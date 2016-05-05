//
//  GatewayInitialLoadingViewModel.swift
//  Accented
//
//  Created by You, Tiangong on 5/4/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class GatewayInitialLoadingViewModel: StreamViewModel {

    // Renderers
    private let initialLoadingRendererReuseIdentifier = "initialLoading"
    private let cardHeaderRendererReuseIdentifier = "cardHeader"
    
    private var loadingCell : StreamInitialLoadingCell?
    
    override func registerCellTypes() {
        let headerCellNib = UINib(nibName: "StreamHeaderCell", bundle: nil)
        collectionView.registerNib(headerCellNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cardHeaderRendererReuseIdentifier)

        let loadingCellNib = UINib(nibName: "StreamInitialLoadingCell", bundle: nil)
        collectionView.registerNib(loadingCellNib, forCellWithReuseIdentifier: initialLoadingRendererReuseIdentifier)
    }
    
    override func createLayoutEngine() {
        let screenSize = UIScreen.mainScreen().bounds

        layoutEngine = GatewayInitialLoadingLayout()
        layoutEngine.itemSize = CGSizeMake(screenSize.width, 150)
        layoutEngine.headerReferenceSize = CGSizeMake(50, 50)
        layoutEngine.footerReferenceSize = CGSizeZero
    }
    
    override func updateCollectionView(shouldRefresh : Bool) {
        
    }
    
    override func streamDidUpdate(notification : NSNotification) -> Void {
        
    }
    
    // MARK: - UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(initialLoadingRendererReuseIdentifier, forIndexPath: indexPath) as! StreamInitialLoadingCell
        loadingCell = cell
        
        return cell
    }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let streamHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: cardHeaderRendererReuseIdentifier, forIndexPath: indexPath) as! StreamHeaderCell
            streamHeaderView.stream = stream
            streamHeaderView.setNeedsLayout()
            return streamHeaderView
        } else {
            return UICollectionReusableView()
        }
    }
}
