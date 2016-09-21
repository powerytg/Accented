//
//  APIService+Cache.swift
//  Accented
//
//  Created by Tiangong You on 8/20/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import AwesomeCache

extension APIService {
    
    internal func initializeCache() {
        do {
            cacheController = try Cache<NSData>(name: "accented.cache")
        } catch let error {
            debugPrint("APIService: Cache initialization failed! Error: \(error)")
        }
    }
    
    internal func putToCache(_ response : Data, forKey key : String?) {
        guard key != nil else { return }
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard self != nil else { return }
            self!.cacheController?.setObject(NSData(data : response), forKey: key!, expires: self!.cacheExpiration)
        }
    }
    
    internal func getFromCache(_ key : String?) -> Data? {
        guard key != nil else { return nil }
        guard let data = cacheController?[key!] else { return nil }
        return data as Data
    }
    
    func removeExpiredCache() {
        cacheController?.removeExpiredObjects()
    }
}
