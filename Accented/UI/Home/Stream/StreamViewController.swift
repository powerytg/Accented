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
        super.init()
        
        // Events
        NotificationCenter.default.addObserver(self, selector: #selector(streamDidUpdate(_:)), name: StorageServiceEvents.streamDidUpdate, object: nil)

        // Make a protective copy of the stream object
        StorageService.sharedInstance.synchronized(stream) { 
            self.stream = stream.copy() as! StreamModel
        }
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
        // Make a protective copy of the stream object
        StorageService.sharedInstance.synchronized(newStream) {
            self.stream = newStream.copy() as! StreamModel
        }

        // Load stream if necessary
        if let vm = streamViewModel {
            vm.stream = stream
            vm.loadStreamIfNecessary()
        }
    }
    
    func streamDidUpdate(_ notification : Notification) -> Void {
        let streamId = notification.userInfo![StorageServiceEvents.streamId] as! String
        let page = notification.userInfo![StorageServiceEvents.page] as! Int
        if streamId != stream.streamId {
            return
        }
        
        // Make a protective copy of the stream object
        var streamModel : StreamModel
        if stream is PhotoSearchStreamModel {
            let searchModel = stream as! PhotoSearchStreamModel
            if let keyword = searchModel.keyword {
                streamModel = StorageService.sharedInstance.getStream(keyword: keyword)
            } else if let tag = searchModel.tag {
                streamModel = StorageService.sharedInstance.getStream(tag: tag)
            } else {
                fatalError("Both keyword and tag cannot be nil")
            }
        } else {
            streamModel = StorageService.sharedInstance.getStream(stream.streamType)
        }
        
        StorageService.sharedInstance.synchronized(streamModel) {
            self.stream = streamModel.copy() as! StreamModel
        }

        if let vm = streamViewModel {
            vm.streamDidUpdate(stream: stream, page: page)
        }
    }
}
