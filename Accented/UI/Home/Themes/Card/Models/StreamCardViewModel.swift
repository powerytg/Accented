//
//  StreamCardViewModel.swift
//  Accented
//
//  Created by You, Tiangong on 8/25/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class StreamCardViewModel: HomeStreamViewModel {
    override var cardRendererReuseIdentifier : String {
        return "cardRenderer"
    }
    
    override func createCollectionViewLayout() {
        let defaultLayout = StreamCardLayout()
        defaultLayout.delegate = self
        layout = defaultLayout
        
        layout.footerReferenceSize = CGSize(width: 50, height: 50)
    }

    override func registerCellTypes() {
        collectionView.register(StreamCardPhotoCell.self, forCellWithReuseIdentifier: cardRendererReuseIdentifier)
        
        // Header navigation cell
        let headerNavCellNib = UINib(nibName: "DefaultStreamHeaderNavCell", bundle: nil)
        collectionView.register(headerNavCellNib, forCellWithReuseIdentifier: headerNavReuseIdentifier)
        
        // Header buttons cell
        let headerButtonsCellNib = UINib(nibName: "DefaultStreamButtonsCell", bundle: nil)
        collectionView.register(headerButtonsCellNib, forCellWithReuseIdentifier: headerButtonsReuseIdentifier)
    }

    override func createLayoutTemplateGenerator(_ maxWidth: CGFloat) -> StreamTemplateGenerator {
        return PhotoCardTemplateGenerator(maxWidth: maxWidth)
    }
    
    override func photoCellAtIndexPath(_ indexPath : IndexPath) -> UICollectionViewCell {
        let group = photoGroups[(indexPath as NSIndexPath).section - photoStartSection]
        let photo = group[(indexPath as NSIndexPath).item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardRendererReuseIdentifier, for: indexPath) as! StreamPhotoCellBaseCollectionViewCell
        cell.photo = photo
        cell.renderer.delegate = self
        cell.setNeedsLayout()
        
        return cell
    }
}
