//
//  StreamCardViewModel.swift
//  Accented
//
//  Created by You, Tiangong on 8/25/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class StreamCardViewModel: DefaultViewModel {
    
    private let cardRendererReuseIdentifier = "journalCardRenderer"
    
    override func registerCellTypes() {
        super.registerCellTypes()
        collectionView.register(StreamCardPhotoCell.self, forCellWithReuseIdentifier: cardRendererReuseIdentifier)
    }

    override func createCollectionViewLayout() {
        let defaultLayout = StreamCardLayout()
        defaultLayout.delegate = self
        layout = defaultLayout
        layout.headerReferenceSize = CGSize(width: 50, height: 50)
        layout.footerReferenceSize = CGSize(width: 50, height: 50)
    }

    override func createLayoutTemplateGenerator(_ maxWidth: CGFloat) -> StreamTemplateGenerator {
        return PhotoCardTemplateGenerator(maxWidth: maxWidth)
    }

    override func photoCellAtIndexPath(_ indexPath : IndexPath) -> UICollectionViewCell {
        let group = photoGroups[(indexPath as NSIndexPath).section - photoStartSection]
        let photo = group[(indexPath as NSIndexPath).item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardRendererReuseIdentifier, for: indexPath) as! StreamCardPhotoCell
        cell.photo = photo
        cell.renderer.delegate = self
        cell.setNeedsLayout()
        
        return cell
    }
}
