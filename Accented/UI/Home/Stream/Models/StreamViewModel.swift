//
//  StreamViewModel.swift
//  Accented
//
//  Created by Tiangong You on 5/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamViewModel: InfiniteLoadingViewModel {

    typealias PhotoGroupModel = [PhotoModel]
    
    // Reference to the stream model
    unowned var stream : StreamModel
    
    // Currently available photo count in the collection view
    var photoCountInCollectionView = 0
    
    var photoStartSection : Int {
        return 0
    }
    
    // Layout generator
    var layoutGenerator : StreamTemplateGenerator = StreamTemplateGenerator()
    
    // Layout engine
    var layoutEngine = StreamLayoutBase()
    
    // PhotoGroups serve as the view model for the stream. These models are in strict sync with layout templates
    var photoGroups  = [PhotoGroupModel]()
    
    required init(stream : StreamModel, collectionView : UICollectionView, flowLayoutDelegate: UICollectionViewDelegateFlowLayout) {
        self.stream = stream        
        super.init(collectionView)
        
        // Register renderer types
        registerCellTypes()

        // Initialize layout
        createLayoutEngine()
        layoutEngine.layoutDelegate = flowLayoutDelegate
        
        let availableWidth = UIScreen.main.bounds.size.width - layoutEngine.leftMargin - layoutEngine.rightMargin
        layoutGenerator = createLayoutTemplateGenerator(availableWidth)
        
        // Attach layout to collection view
        collectionView.collectionViewLayout = layoutEngine
        
        // If the stream is not loaded, show the loading state
        if !stream.loaded {
            layoutEngine.generateLayoutAttributesForLoadingState()
            collectionView.reloadData()
        }        
    }
    
    func registerCellTypes() -> Void {
        fatalError("Not implemented in base class")
    }
    
    func createLayoutEngine() {
        fatalError("Not implemented in base class")
    }
    
    func createLayoutTemplateGenerator(_ maxWidth : CGFloat) -> StreamTemplateGenerator {
        fatalError("Not implemented in base class")
    }
    
    func loadStreamIfNecessary() {
        if !stream.loaded {
            // Scroll to top of the stream
            collectionView.setContentOffset(CGPoint.zero, animated: false)
            clearCollectionView()
            
            layoutEngine.generateLayoutAttributesForLoadingState()
            collectionView.reloadData()
            loadNextPage()
        } else {
            updateCollectionView(true)
        }
    }
    
    // MARL: - Stream loading and updating
    
    fileprivate func loadPage(_ page : Int) {
        if stream is PhotoSearchStreamModel {
            searchPhotos(page: page)
        } else {
            loadPhotos(page: page)
        }
    }
    
    fileprivate func loadPhotos(page : Int) {
        let params = ["tags" : "1"]
        APIService.sharedInstance.getPhotos(streamType: stream.streamType, page: page, parameters: params, success: nil, failure: { [weak self] (errorMessage) in
            self?.streamFailedRefreshing(errorMessage)
        })
    }
    
    fileprivate func searchPhotos(page : Int) {
        let searchModel = stream as! PhotoSearchStreamModel
        if let keyword = searchModel.keyword {
            APIService.sharedInstance.searchPhotos(keyword : keyword, page: page, parameters: [:], success: nil, failure: { [weak self] (errorMessage) in
                self?.streamFailedRefreshing(errorMessage)
            })
        } else if let tag = searchModel.tag {
            APIService.sharedInstance.searchPhotos(tag : tag, page: page, parameters: [:], success: nil, failure: { [weak self] (errorMessage) in
                self?.streamFailedRefreshing(errorMessage)
            })
        }
    }

    override func refresh() {
        if streamState.refreshing {
            return
        }
        
        streamState.refreshing = true
        loadPage(1)
    }
    
    override func loadNextPage() {
        if streamState.loading {
            return
        }
        
        streamState.loading = true
        let page = Int(ceil(Float(stream.photos.count) / Float(StorageService.pageSize))) + 1
        loadPage(page)
    }
    
    func streamDidUpdate(stream : StreamModel, page : Int) -> Void {
        self.stream = stream

        // Update the stream, refresh if page is 1
        updateCollectionView(page == 1)
        streamState.loading = false
        
        if page == 1 {
            streamState.refreshing = false
            delegate?.viewModelDidRefresh()
        }
    }
    
    func streamFailedLoading(_ error : String) {
        debugPrint(error)
        streamState.loading = false
    }

    func streamFailedRefreshing(_ error : String) {
        debugPrint(error)
        streamState.refreshing = false
    }

    func clearCollectionView() {
        photoCountInCollectionView = 0
        photoGroups.removeAll()
        layoutEngine.clearLayoutCache()
    }
    
    override func updateCollectionView(_ shouldRefresh : Bool) {
        // If stream needs refresh (page is 1), then clear all the previous layout metadata and group info
        if shouldRefresh {
            clearCollectionView()
        }
        
        // Generate layout templates for the new photos. Since we already know the number of items currently displayed in the collection
        // view, we'll use this number as start index and generate layout templates for all the images that come after the index
        let sectionStartIndex = photoStartSection + photoGroups.count
        let startIndex = photoCountInCollectionView
        let endIndex = stream.photos.count - 1
        let photosForProcessing = Array(stream.photos[startIndex...endIndex])
        let templates = layoutGenerator.generateLayoutMetadata(photosForProcessing)
        
        // Sync photo groups with layout templates
        var photoGroupIndex = startIndex
        for template in templates {
            let groupSize = template.frames.count
            let group = Array(stream.photos[photoGroupIndex...photoGroupIndex + groupSize - 1])
            photoGroups.append(group)
            photoGroupIndex += groupSize
        }
        
        photoCountInCollectionView += photosForProcessing.count
        
        // Sync templates with layout engine
        layoutEngine.generateLayoutAttributesForTemplates(templates, sectionStartIndex: sectionStartIndex)
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        fatalError("Not implemented in base class")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fatalError("Not implemented in base class")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("Not implemented in base class")
    }
    
}
