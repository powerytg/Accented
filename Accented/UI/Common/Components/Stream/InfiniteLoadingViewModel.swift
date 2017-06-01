//
//  InfiniteLoadingViewModel.swift
//  Accented
//
//  Base view model for continuously a loadable stream
//
//  Created by You, Tiangong on 10/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

protocol InfiniteLoadingViewModelDelegate : NSObjectProtocol {
    func viewModelDidRefresh()
    func viewModelDidUpdate()
}

class InfiniteLoadingViewModel<T : ModelBase>: NSObject, UICollectionViewDataSource, InfiniteLoadable {
    let initialLoadingRendererReuseIdentifier = "initialLoading"
    let loadingFooterRendererReuseIdentifier = "loadingFooter"
    let invisiblePlaceholderFooterReuseIdentifier = "placeholderFooter"
    let invisiblePlaceholderHeaderReuseIdentifier = "placeholderHeader"

    // Reference to the collection view
    var collectionView : UICollectionView
    
    // Stream state
    var streamState = StreamState()

    // Delegate
    weak var delegate : InfiniteLoadingViewModelDelegate?

    // Data model
    var collection : CollectionModel<T>
    
    // Collection view layout
    var layout : InfiniteLoadingLayout<T>!

    // Inline infinite loading cell
    var loadingCell : DefaultStreamInlineLoadingCell?

    init(collection : CollectionModel<T>, collectionView : UICollectionView) {
        self.collection = collection
        self.collectionView = collectionView
        super.init()
        
        // Register common cell types 
        // Inline loading
        let loadingCellNib = UINib(nibName: "DefaultStreamInlineLoadingCell", bundle: nil)
        collectionView.register(loadingCellNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: loadingFooterRendererReuseIdentifier)
        
        // Initial loading
        let initialLoadingCellNib = UINib(nibName: "DefaultStreamInitialLoadingCell", bundle: nil)
        collectionView.register(initialLoadingCellNib, forCellWithReuseIdentifier: initialLoadingRendererReuseIdentifier)
        
        // Invisible header and footer used as a placeholder
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: invisiblePlaceholderHeaderReuseIdentifier)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: invisiblePlaceholderFooterReuseIdentifier)
        
        // Create layout engine
        createCollectionViewLayout()
        collectionView.collectionViewLayout = layout
        
        // If the collection is not loaded, show the loading state
        if !collection.loaded {
            layout.generateLayoutAttributesForLoadingState()
            collectionView.reloadData()
        }
    }
    
    func createCollectionViewLayout() {
        fatalError("Not implemented in base class")
    }
    
    // MARL: - Stream loading and updating
    
    func loadIfNecessary() {
        if !collection.loaded {
            // Scroll to top of the stream
            collectionView.setContentOffset(CGPoint.zero, animated: false)
            clearCollectionView()
            
            // Generate the layout attributes for the loading spinner
            layout.generateLayoutAttributesForLoadingState()
            collectionView.reloadData()
            loadNextPage()
        } else {
            updateCollectionView(true)
        }
    }
    
    func loadPageAt(_ page : Int) {
        fatalError("Not implemented in base class")
    }
    
    func loadNextPage() {
        if streamState.loading {
            return
        }

        streamState.loading = true
        let page = Int(ceil(Float(collection.items.count) / Float(StorageService.pageSize))) + 1
        loadPageAt(page)
    }
    
    func refresh() {
        if streamState.refreshing {
            return
        }
        
        streamState.refreshing = true
        loadPageAt(1)
    }
    
    func canLoadMore() -> Bool {
        return collection.totalCount! > collection.items.count
    }
    
    func collecitonDidUpdate(collection : CollectionModel<T>, page : Int) -> Void {
        self.collection = collection
        
        // Update the stream, refresh if page is 1
        updateCollectionView(page == 1)
        streamState.loading = false
        
        if page == 1 {
            streamState.refreshing = false
            delegate?.viewModelDidRefresh()
        }
        
        delegate?.viewModelDidUpdate()
    }
    
    func collectionFailedLoading(_ error : String) {
        debugPrint(error)
        streamState.loading = false
        
        if let loadingView = self.loadingCell {
            loadingView.showRetryState()
        }
    }
    
    func collectionFailedRefreshing(_ error : String) {
        debugPrint(error)
        streamState.refreshing = false
    }
    
    func updateCollectionView(_ shouldRefresh : Bool) {
        // If stream needs refresh (page is 1), then clear all the previous layout metadata and group info
        if shouldRefresh {
            clearCollectionView()
        }
        
        // Update the collection view
        layout.collection = collection
        layout.generateLayoutAttributesIfNeeded()
        collectionView.reloadData()
    }
    
    func clearCollectionView() {
        layout.clearLayoutCache()
    }

    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("Not implemented in base class")
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            // If the stream has more content, show the loading cell for the last section
            let loadingView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: loadingFooterRendererReuseIdentifier, for: indexPath) as! DefaultStreamInlineLoadingCell
            loadingView.viewModel = self
            self.loadingCell = loadingView
            if canLoadMore() {
                // If there are no more items in the stream to load, show the ending status
                if collection.items.count >= collection.totalCount! {
                    loadingView.showEndingState()
                } else {
                    // Otherwise, always show the loading state, even if the previous attempt of loading failed. This is because we'll trigger loadNextPage() regardless of footer state
                    loadingView.showLoadingState()
                }
            } else {
                loadingView.showEndingState()
            }
            
            return loadingView
        }
        
        // Should never reach this line
        fatalError("Unsupported element type!")
    }
}
