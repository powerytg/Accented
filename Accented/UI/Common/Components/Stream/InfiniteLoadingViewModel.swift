//
//  InfiniteLoadingViewModel.swift
//  Accented
//
//  Created by You, Tiangong on 10/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

protocol InfiniteLoadingViewModelDelegate : NSObjectProtocol {
    func viewModelDidRefresh()
}

class InfiniteLoadingViewModel: NSObject, UICollectionViewDataSource {

    // Reference to the collection view
    unowned var collectionView : UICollectionView
    
    // Stream state
    var streamState = StreamState()

    // Delegate
    weak var delegate : InfiniteLoadingViewModelDelegate?

    init(_ collectionView : UICollectionView) {
        self.collectionView = collectionView
        super.init()
    }
    
    func loadNextPage() {
        // Not implemented in base class
    }
    
    func refresh() {
        // Not implemented in base class
    }
    
    func updateCollectionView(_ shouldRefresh : Bool) {
        // Not implemented in base class
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("Not implemented in base class")
    }
}
