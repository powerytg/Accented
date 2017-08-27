//
//  TagSearchResultCardViewModel.swift
//  Accented
//
//  Created by Tiangong You on 8/26/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class TagSearchResultCardViewModel: TagSearchResultViewModel {
   
    override var cardRendererReuseIdentifier : String {
        return "cardRenderer"
    }

    override func registerCellTypes() {
        super.registerCellTypes()
        collectionView.register(StreamCardPhotoCell.self, forCellWithReuseIdentifier: cardRendererReuseIdentifier)
    }
    
    override func createLayoutTemplateGenerator(_ maxWidth: CGFloat) -> StreamTemplateGenerator {
        return PhotoCardTemplateGenerator(maxWidth: maxWidth)
    }
}
