//
//  StreamViewController.swift
//  Accented
//
//  Created by Tiangong You on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamViewController : InfiniteLoadingViewController {
    // Data model
    var stream : StreamModel!

    // View model
    var streamViewModel : StreamViewModel? {
        return viewModel as? StreamViewModel
    }
    
    init(_ stream : StreamModel) {
        self.stream = stream
        super.init()
        
        // Events
        NotificationCenter.default.addObserver(self, selector: #selector(streamDidUpdate(_:)), name: StorageServiceEvents.streamDidUpdate, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load stream if necessary
        if let vm = streamViewModel {
            vm.stream = stream
            vm.loadStreamIfNecessary()
        }
    }
    
    func switchStream(_ newStream : StreamModel) {
        self.stream = newStream

        // Load stream if necessary
        if let vm = streamViewModel {
            vm.stream = stream
            vm.loadStreamIfNecessary()
        }
    }
    
    func streamDidUpdate(_ notification : Notification) -> Void {
        let streamId = notification.userInfo![StorageServiceEvents.streamId] as! String
        let page = notification.userInfo![StorageServiceEvents.page] as! Int
        guard streamId == stream.streamId else { return }
        
        // Get a new copy of the stream
        if stream is PhotoSearchStreamModel {
            let searchModel = stream as! PhotoSearchStreamModel
            if let keyword = searchModel.keyword {
                stream = StorageService.sharedInstance.getPhotoSearchResult(keyword: keyword)
            } else if let tag = searchModel.tag {
                stream = StorageService.sharedInstance.getPhotoSearchResult(tag: tag)
            } else {
                fatalError("Both keyword and tag cannot be nil")
            }
        } else {
            stream = StorageService.sharedInstance.getStream(stream.streamType)
        }

        if let vm = streamViewModel {
            vm.streamDidUpdate(stream: stream, page: page)
        }
    }
}
