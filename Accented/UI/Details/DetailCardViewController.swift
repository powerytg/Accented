//
//  DetailCardViewController.swift
//  Accented
//
//  Created by You, Tiangong on 8/5/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailCardViewController: DeckViewController, DeckViewControllerDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - DeckViewControllerDataSource
    
    func numberOfCards() -> Int {
        return 5
    }
    
    func cardForItemIndex(itemIndex: Int) -> CardViewController {
        var card = getRecycledCardViewController()
        if card == nil {
            card = CardViewController()
        }
        
        return card!
    }

}
