//
//  GatewayViewModel.swift
//  Accented
//
//  Created by Tiangong You on 5/2/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class GatewayViewModel: StreamViewModel {
    // Renderers
    private let cardRendererReuseIdentifier = "card"
    private let cardHeaderRendererReuseIdentifier = "cardHeader"
    private let cardSectionHeaderRendererReuseIdentifier = "cardSectionHeader"
    private let cardSectionFooterRendererReuseIdentifier = "cardSectionFooter"
    
    required init(stream : StreamModel, collectionView : UICollectionView, flowLayoutDelegate: UICollectionViewDelegateFlowLayout) {
        super.init(stream: stream, collectionView: collectionView, flowLayoutDelegate: flowLayoutDelegate)
    }
    
    override func registerCellTypes() {
        collectionView.registerClass(StreamPhotoCell.self, forCellWithReuseIdentifier: cardRendererReuseIdentifier)
        
        let headerCellNib = UINib(nibName: "StreamHeaderCell", bundle: nil)
        collectionView.registerNib(headerCellNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cardHeaderRendererReuseIdentifier)
        
        let sectionHeaderCellNib = UINib(nibName: "StreamSectionHeaderCell", bundle: nil)
        collectionView.registerNib(sectionHeaderCellNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cardSectionHeaderRendererReuseIdentifier)
        
        let sectionFooterCellNib = UINib(nibName: "StreamSectionFooterCell", bundle: nil)
        collectionView.registerNib(sectionFooterCellNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: cardSectionFooterRendererReuseIdentifier)
    }
    
    override func createLayoutEngine() {
        layoutEngine = GatewayCardLayout()
        layoutEngine.headerReferenceSize = CGSizeMake(50, 50)
        layoutEngine.footerReferenceSize = CGSizeMake(50, 50)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let group = photoGroups[indexPath.section]
        let photo = group[indexPath.item]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cardRendererReuseIdentifier, forIndexPath: indexPath) as! StreamPhotoCell
        cell.photo = photo
        cell.setNeedsLayout()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let group = photoGroups[indexPath.section]
        
        if kind == UICollectionElementKindSectionHeader {
            if indexPath.section == 0 {
                let streamHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: cardHeaderRendererReuseIdentifier, forIndexPath: indexPath) as! StreamHeaderCell
                streamHeaderView.stream = stream
                streamHeaderView.setNeedsLayout()
                return streamHeaderView
            } else {
                let sectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: cardSectionHeaderRendererReuseIdentifier, forIndexPath: indexPath) as! StreamSectionHeaderCell
                return sectionHeaderView
            }
        } else if kind == UICollectionElementKindSectionFooter {
            let sectionFooterView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: cardSectionFooterRendererReuseIdentifier, forIndexPath: indexPath) as! StreamSectionFooterCell
            sectionFooterView.photoGroup = group
            sectionFooterView.setNeedsLayout()
            return sectionFooterView
        }
        
        return UICollectionViewCell()
    }
}
