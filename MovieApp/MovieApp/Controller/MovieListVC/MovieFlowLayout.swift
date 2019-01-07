//
//  MovieFlowLayout.swift
//  MovieApp
//
//  Created by Ketan on 1/4/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit

open class MovieFlowLayout: UICollectionViewFlowLayout {
    
    //MARK:- IBInspectable values for set UI
    @IBInspectable open var sideItemScale: CGFloat = 0.6
    @IBInspectable open var sideItemAlpha: CGFloat = 0.6
    @IBInspectable open var sideItemShift: CGFloat = 0.0
    open var spacingMode = -30
    
    override open func prepare() {
        super.prepare()
        self.setupCollectionView()
        self.updateLayout()
    }
    
    fileprivate func setupCollectionView() {
        
        guard let collectionView = self.collectionView else { return }
        
        if collectionView.decelerationRate != UIScrollView.DecelerationRate.fast {
            collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        }
    }
    
    fileprivate func updateLayout() {
        
        guard let collectionView = self.collectionView else { return }
        
        let collectionSize = collectionView.bounds.size
        let isHorizontal = (self.scrollDirection == .horizontal)
        
        let yInset = (collectionSize.height - self.itemSize.height) / 2
        let xInset = (collectionSize.width - self.itemSize.width) / 2
        self.sectionInset = UIEdgeInsets.init(top: yInset, left: xInset, bottom: yInset, right: xInset)
        
        let side = isHorizontal ? self.itemSize.width : self.itemSize.height
        let scaledItemOffset =  (side - side*self.sideItemScale) / 2
        self.minimumLineSpacing = CGFloat(spacingMode) - scaledItemOffset
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
            else { return nil }
        return attributes.map({ self.transformLayoutAttributes($0) })
    }
    
    fileprivate func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        guard let collectionView = self.collectionView else { return attributes }
        
        let collectionCenter = collectionView.frame.size.width/2
        let offset = collectionView.contentOffset.x
        let normalizedCenter = attributes.center.x - offset
        
        let maxDistance = self.itemSize.width + self.minimumLineSpacing
        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
        let ratio = (maxDistance - distance)/maxDistance
        
        let alpha = ratio * (1 - self.sideItemAlpha) + self.sideItemAlpha
        let scale = ratio * (1 - self.sideItemScale) + self.sideItemScale
        let shift = (1 - ratio) * self.sideItemShift
        attributes.alpha = alpha
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        attributes.zIndex = Int(alpha * 10)
        
        if let cell = collectionView.cellForItem(at: attributes.indexPath) as? MovieCell {
            cell.btnBuyTicket.alpha = ratio
        }
        
        attributes.center.y = attributes.center.y + shift
        
        return attributes
    }
    
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = collectionView , !collectionView.isPagingEnabled,
            let layoutAttributes = self.layoutAttributesForElements(in: collectionView.bounds)
            else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
        
        let midSide = collectionView.bounds.size.width / 2
        let proposedContentOffsetCenterOrigin = proposedContentOffset.x + midSide
        
        var targetContentOffset: CGPoint
        let closest = layoutAttributes.sorted { abs($0.center.x - proposedContentOffsetCenterOrigin) < abs($1.center.x - proposedContentOffsetCenterOrigin) }.first ?? UICollectionViewLayoutAttributes()
        targetContentOffset = CGPoint(x: floor(closest.center.x - midSide), y: proposedContentOffset.y)
        
        return targetContentOffset
    }
}

