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

class PhotoSearchFilterModel: NSObject {
    // Current selected sorting option (specific to this model)
    var selectedOption : PhotoSearchSortingOptions
    
    // Support sorting options for photo search, in order
    var supportedPhotoSearchSortingOptions : [PhotoSearchSortingOptions] = [.highestRating, .timesViewed, .createdAt, .rating]
    
    override init() {
        selectedOption = StorageService.sharedInstance.currentPhotoSearchSortingOption
        super.init()
    }
}
