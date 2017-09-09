//
//  GallerySortingModel.swift
//  Accented
//
//  Gallery stream sorting model
//
//  Created by Tiangong You on 9/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class GallerySortingModel: MenuModel {
    override init() {
        super.init()
        
        items = [GallerySortingOptionMenuItem(option: .position, text: "Default (User Specified)"),
                 GallerySortingOptionMenuItem(option: .highestRating, text: "Top Rated"),
                 GallerySortingOptionMenuItem(option: .timesViewed, text: "Most Viewed"),
                 GallerySortingOptionMenuItem(option: .createdAt, text: "Latest"),
                 GallerySortingOptionMenuItem(option: .rating, text: "Most Popular")]
        
        // By default, the sorting order is specified by the owner of the gallery
        selectedItem = items[0]
    }
}
