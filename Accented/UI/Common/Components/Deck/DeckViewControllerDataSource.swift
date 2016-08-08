//
//  DeckViewControllerDataSource.swift
//  Accented
//
//  Created by You, Tiangong on 8/5/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

protocol DeckViewControllerDataSource: NSObjectProtocol {
    func cardForItemIndex(itemIndex : Int) -> CardViewController
    func numberOfCards() -> Int
}
