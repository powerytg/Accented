//
//  SearchResultSortingBottomSheetViewController.swift
//  Accented
//
//  Created by Tiangong You on 5/25/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class SearchResultSortingBottomSheetViewController: SheetMenuViewController {

    override init(model: MenuModel) {
        super.init(model: model)
        
        for (index, entry) in model.items.enumerated() {
            let option = entry as! SortingOptionMenuItem
            if option.option == StorageService.sharedInstance.currentPhotoSearchSortingOption {
                initialSelectedIndex = index
                break
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
