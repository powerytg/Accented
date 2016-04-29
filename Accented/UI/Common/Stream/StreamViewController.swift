//
//  StreamViewController.swift
//  Accented
//
//  Created by Tiangong You on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var streamCollectionView: UICollectionView!
    var stream:StreamModel?
    let reuseIdentifier = "photoRenderer"
    
    var loading = false
    var streamLayout = StreamCardLayout()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init() {
        self.init(nibName : "StreamViewController", bundle: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cell type registration
        streamCollectionView.registerClass(StreamPhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        streamCollectionView.dataSource = self
        streamCollectionView.delegate = self
        streamCollectionView.collectionViewLayout = streamLayout

        // Initialize events
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(streamDidUpdate(_:)), name: StorageServiceEvents.streamDidUpdate, object: nil)
        
        // Load the first page
        APIService.sharedInstance.getPhotos(StreamType.Popular)
    }

    func streamDidUpdate(notification : NSNotification) -> Void {
        let streamTypeString = notification.userInfo![StorageServiceEvents.streamType] as! String
        let streamType = StreamType(rawValue: streamTypeString)
        if streamType == stream?.streamType {
            streamLayout.photos = stream!.photos
            streamCollectionView.reloadData()
        }
        
        loading = false
    }

    // MARK: - UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (stream?.photos.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let photo = stream?.photos[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! StreamPhotoCollectionViewCell
        cell.photo = photo
        
        return cell
    }
    
    // MARK: - Infinite scrolling
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height - 50 {
            loadNextPage()
        }
    }
    
    func loadNextPage() -> Void {
        if loading {
            return
        }
        
        let page = stream!.photos.count / StorageService.pageSize + 1
        APIService.sharedInstance.getPhotos(stream!.streamType, page: page, parameters: [:]);
    }
    
    
}
