//
//  InfiniteLoadable.swift
//  Accented
//
//  Protocol that represents a continuously loadable stream
//
//  Created by Tiangong You on 5/24/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

protocol InfiniteLoadable : NSObjectProtocol {
    func loadNextPage()
    func canLoadMore() -> Bool
}

