//
//  RenderService.swift
//  Accented
//
//  Created by You, Tiangong on 8/25/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class RenderService: NSObject {

    // Singleton instance
    static let sharedInstance = RenderService()
    
    // Render queue
    private let renderQueue : dispatch_queue_t
    
    // Rendered bitmap cache. This is thread safe
    private var renderCache : NSCache
    
    private override init() {
        renderQueue = dispatch_queue_create("com.accented.renderer", nil)
        renderCache = NSCache()
    }

    func getCachedImage(identifier : String) -> (identifier : String, cachedImage : UIImage?) {
        let cachedImage = renderCache.objectForKey(identifier) as? UIImage
        return (identifier : identifier, cachedImage : cachedImage)
    }
    
    func setCachedImage(identifier : String, image : UIImage) {
        renderCache.setObject(image, forKey: identifier)
    }
    
}
