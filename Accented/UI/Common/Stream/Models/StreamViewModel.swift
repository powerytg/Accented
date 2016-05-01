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
    
    // Reference to the collection view
    unowned var collectionView : UICollectionView
    
    // Layout generator
    var layoutGenerator : StreamTemplateGenerator
    
    // Layout engine
    var layoutEngine : StreamLayoutBase
    
    // Stream state
    var streamState = StreamState()
    
    // Renderers
    private let cardRendererReuseIdentifier = "cardRenderer"
    
    // PhotoGroups serve as the view model for the stream. These models are in strict sync with layout templates
    var photoGroups  = [PhotoGroupModel]()
    
    required init(stream : StreamModel, collectionView : UICollectionView) {
        self.stream = stream
        self.collectionView = collectionView
        
        // Initialize layout
        layoutEngine = StreamCardLayout()
        layoutEngine.headerReferenceSize = CGSizeMake(50, 50)

        let availableWidth = UIScreen.mainScreen().bounds.size.width - layoutEngine.leftMargin - layoutEngine.rightMargin
        layoutGenerator = StreamCardLayoutGenerator(maxWidth: availableWidth)

        super.init()
        
        // Register renderer types
        collectionView.registerClass(StreamPhotoCollectionViewCell.self, forCellWithReuseIdentifier: cardRendererReuseIdentifier)
        
        // Attach layout to collection view
        collectionView.collectionViewLayout = layoutEngine
        
        // Events
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(streamDidUpdate(_:)), name: StorageServiceEvents.streamDidUpdate, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARL: - Stream loading and updating
    func loadNextPage() -> Void {
        if streamState.loading {
            return
        }
        
        streamState.loading = true
        let page = stream.photos.count / StorageService.pageSize + 1
        APIService.sharedInstance.getPhotos(stream.streamType, page: page, parameters: [:]);
    }
    
    func streamDidUpdate(notification : NSNotification) -> Void {
        let streamTypeString = notification.userInfo![StorageServiceEvents.streamType] as! String
        let streamType = StreamType(rawValue: streamTypeString)
        let page = notification.userInfo![StorageServiceEvents.page] as! Int
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
    
    func updateCollectionView(shouldRefresh : Bool) {
        // If stream needs refresh (page is 1), then clear all the previous layout metadata and group info
        if shouldRefresh {
            photoCountInCollectionView = 0
            photoGroups.removeAll()
            layoutEngine.clearLayoutCache()
        }
        
        // Generate layout templates for the new photos. Since we already know the number of items currently displayed in the collection
        // view, we'll use this number as start index and generate layout templates for all the images that come after the index
        let sectionStartIndex = photoGroups.count
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
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return photoGroups.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoGroups[section].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let group = photoGroups[indexPath.section]
        let photo = group[indexPath.item]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cardRendererReuseIdentifier, forIndexPath: indexPath) as! StreamPhotoCollectionViewCell
        cell.photo = photo
        cell.setNeedsLayout()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return UICollectionViewCell()
    }
    
}
