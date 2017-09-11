//
//  StreamViewModel.swift
//  Accented
//
//  Generic photo stream view model
//
//  Created by Tiangong You on 5/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import RMessage

class StreamViewModel: InfiniteLoadingViewModel<PhotoModel> {

    typealias PhotoGroupModel = [PhotoModel]
    
    // Currently available photo count in the collection view
    var photoCountInCollectionView = 0
    
    var photoStartSection : Int {
        return 0
    }
    
    // Template generator
    var layoutGenerator : StreamTemplateGenerator = StreamTemplateGenerator()
    
    // PhotoGroups serve as the view model for the stream. These models are in strict sync with layout templates
    var photoGroups  = [PhotoGroupModel]()
    
    var streamLayout : StreamLayoutBase {
        return layout as! StreamLayoutBase
    }
    
    var stream : StreamModel {
        return collection as! StreamModel
    }
    
    required init(stream : StreamModel, collectionView : UICollectionView, flowLayoutDelegate: UICollectionViewDelegateFlowLayout) {
        super.init(collection: stream, collectionView: collectionView)
        
        // Register renderer types
        registerCellTypes()

        // Initialize layout
        streamLayout.layoutDelegate = flowLayoutDelegate
        
        let availableWidth = UIScreen.main.bounds.size.width - streamLayout.leftMargin - streamLayout.rightMargin
        layoutGenerator = createLayoutTemplateGenerator(availableWidth)        
    }
    
    func registerCellTypes() {
        fatalError("Not implemented in base class")
    }
    
    func createLayoutTemplateGenerator(_ maxWidth : CGFloat) -> StreamTemplateGenerator {
        fatalError("Not implemented in base class")
    }
    
    func photoCellAtIndexPath(_ indexPath : IndexPath) -> UICollectionViewCell {
        fatalError("Not implemented in base class")
    }

    // MARL: - Stream loading and updating
    
    override func loadPageAt(_ page : Int) {
        let params = ["tags" : "1"]
        APIService.sharedInstance.getPhotos(streamType: stream.streamType, page: page, parameters: params, success: nil, failure: { [weak self] (errorMessage) in
            self?.collectionFailedLoading(errorMessage)
            RMessage.showNotification(withTitle: errorMessage, subtitle: nil, type: .error, customTypeName: nil, callback: nil)
        })
    }
    
    override func clearCollectionView() {
        super.clearCollectionView()
        photoCountInCollectionView = 0
        photoGroups.removeAll()
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
        let endIndex = collection.items.count - 1
        
        if endIndex < startIndex {
            debugPrint("End index \(endIndex) is smaller than start index \(startIndex)!")
            delegate?.viewModelDidUpdate()
            return
        }
        
        let photosForProcessing = Array(collection.items[startIndex...endIndex])
        let templates = layoutGenerator.generateLayoutMetadata(photosForProcessing)
        
        // Sync photo groups with layout templates
        var photoGroupIndex = startIndex
        for template in templates {
            let groupSize = template.frames.count
            let group = Array(stream.items[photoGroupIndex...photoGroupIndex + groupSize - 1])
            photoGroups.append(group)
            photoGroupIndex += groupSize
        }
        
        photoCountInCollectionView += photosForProcessing.count
        
        // Sync templates with layout engine
        streamLayout.generateLayoutAttributesForTemplates(templates, sectionStartIndex: sectionStartIndex)
        collectionView.reloadData()
    }
}
