//
//  StreamViewModel.swift
//  Accented
//
//  Created by Tiangong You on 5/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamViewModel: NSObject, UICollectionViewDataSource {

    typealias PhotoGroupModel = [PhotoModel]
    
    // Reference to the stream model
    unowned var stream : StreamModel
    
    // Currently available photo count in the collection view
    var photoCountInCollectionView = 0
    
    var photoStartSection : Int {
        return 0
    }
    
    // Reference to the collection view
    unowned var collectionView : UICollectionView
    
    // Layout generator
    var layoutGenerator : StreamTemplateGenerator = StreamTemplateGenerator()
    
    // Layout engine
    var layoutEngine = StreamLayoutBase()
    
    // Stream state
    var streamState = StreamState()
    
    // PhotoGroups serve as the view model for the stream. These models are in strict sync with layout templates
    var photoGroups  = [PhotoGroupModel]()
    
    required init(stream : StreamModel, collectionView : UICollectionView, flowLayoutDelegate: UICollectionViewDelegateFlowLayout) {
        self.stream = stream
        self.collectionView = collectionView
        
        super.init()
        
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
        
        // Events
        NotificationCenter.default.addObserver(self, selector: #selector(streamDidUpdate(_:)), name: StorageServiceEvents.streamDidUpdate, object: nil)
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    func loadNextPage() -> Void {
        if streamState.loading {
            return
        }
        
        streamState.loading = true
        let page = stream.photos.count / StorageService.pageSize + 1
        let params = ["tags" : "1"]
        APIService.sharedInstance.getPhotos(stream.streamType, page: page, parameters: params, success: nil, failure: { [weak self] (errorMessage) in
            self?.streamFailedLoading(errorMessage)
        })
    }
    
    func streamDidUpdate(_ notification : Notification) -> Void {
        let streamTypeString = (notification as NSNotification).userInfo![StorageServiceEvents.streamType] as! String
        let streamType = StreamType(rawValue: streamTypeString)
        let page = (notification as NSNotification).userInfo![StorageServiceEvents.page] as! Int
        if streamType != stream.streamType {
            return
        }
        
        if stream.photos.count <= photoCountInCollectionView {
            return
        }

        if streamState.scrolling {
            // Put the update in pending
            streamState.dirty = true
        } else {
            updateCollectionView(page == 1)
        }

        streamState.loading = false
    }
    
    func streamFailedLoading(_ error : String) {
        debugPrint(error)
        streamState.loading = false
    }
    
    func clearCollectionView() {
        photoCountInCollectionView = 0
        photoGroups.removeAll()
        layoutEngine.clearLayoutCache()
    }
    
    func updateCollectionView(_ shouldRefresh : Bool) {
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        fatalError("Not implemented in base class")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fatalError("Not implemented in base class")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("Not implemented in base class")
    }
    
}
