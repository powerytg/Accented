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
    var dirty = false
    var scrolling = false
    
    // Layout
    var streamLayout = StreamCardLayout()
    
    // Event delegate
    var delegate : StreamViewControllerDelegate?
    
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
        
        self.view.backgroundColor = UIColor.clearColor()
        
        // Cell type registration
        streamCollectionView.backgroundColor = UIColor.clearColor()
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
            if !scrolling {
                streamLayout.photos = stream!.photos
                streamCollectionView.reloadData()
            } else {
                dirty = true
            }
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
        cell.setNeedsLayout()
        
        return cell
    }
    
    // MARK: - Infinite scrolling
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        scrolling = true
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrolling = false
        
        if dirty {
            dirty = false
            streamLayout.photos = stream!.photos
            streamCollectionView.reloadData()
        }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height - 50 {
            loadNextPage()
        }
        
        // Dispatch events
        let visibleIndexes = streamCollectionView.indexPathsForVisibleItems()
        if visibleIndexes.count > 0 {
            let firstVisibleIndex = visibleIndexes[0]
            let firstVisiblePhoto = stream!.photos[firstVisibleIndex.item]
            delegate?.streamViewDidFinishedScrolling(firstVisiblePhoto)
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
