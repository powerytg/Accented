//
//  PhotoSearchFilterModel.swift
//  Accented
//
//  Photo search filter and sorting model
//
//  Created by Tiangong You on 5/25/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class PhotoSearchFilterModel: MenuModel {
    override init() {
        super.init()

        items = [SortingOptionMenuItem(option: .highestRating, text: "Top Rated"),
                 SortingOptionMenuItem(option: .timesViewed, text: "Most Viewed"),
                 SortingOptionMenuItem(option: .createdAt, text: "Latest"),
                 SortingOptionMenuItem(option: .rating, text: "Most Popular")]
        
        for item in items {
            let sortingOption = item as! SortingOptionMenuItem
            if sortingOption.option == StorageService.sharedInstance.currentPhotoSearchSortingOption {
                selectedItem = sortingOption
            }
        }
    }
}
