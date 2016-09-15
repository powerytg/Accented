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
    fileprivate let renderQueue : DispatchQueue
    
    // Rendered bitmap cache. This is thread safe
    fileprivate var renderCache : NSCache<AnyObject, AnyObject>
    
    fileprivate override init() {
        renderQueue = DispatchQueue(label: "com.accented.renderer", attributes: [])
        renderCache = NSCache()
    }

    func getCachedImage(_ identifier : String) -> (identifier : String, cachedImage : UIImage?) {
        let cachedImage = renderCache.object(forKey: identifier as AnyObject) as? UIImage
        return (identifier : identifier, cachedImage : cachedImage)
    }
    
    func setCachedImage(_ identifier : String, image : UIImage) {
        renderCache.setObject(image, forKey: identifier as AnyObject)
    }
    
}
