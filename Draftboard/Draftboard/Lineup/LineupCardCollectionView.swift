//
//  LineupCardCollectionView.swift
//  Draftboard
//
//  Created by Anson Schall on 4/22/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class LineupCardCollectionView: UICollectionView {
    
    var cardInset: UIEdgeInsets = UIEdgeInsetsZero { didSet { setup() } }
    var cardSize: CGSize { return UIEdgeInsetsInsetRect(frame, cardInset).size }
    
    init() {
        super.init(frame: CGRectZero, collectionViewLayout: PaginatedCollectionViewFlowLayout())
        setup()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    func setup() {
        alwaysBounceHorizontal = true
        backgroundColor = .clearColor()
        clipsToBounds = false
        contentInset = UIEdgeInsetsMake(0, 0, 0, cardInset.right)
        decelerationRate = UIScrollViewDecelerationRateFast
        showsHorizontalScrollIndicator = false
        
        // Use a paginated layout
        let layout = PaginatedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.pageSize = { return self.cardSize }
        layout.scrollDirection = .Horizontal
        layout.sectionInset = UIEdgeInsetsMake(0, cardInset.left, 0, 0)
        collectionViewLayout = layout
        
        // Set perspective for cell transformations. Important!
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 500.0
        layer.sublayerTransform = transform
        
        registerClass(LineupCardCell.self, forCellWithReuseIdentifier: LineupCardCell.reuseIdentifier)
    }
    
    func dequeueReusableCellForIndexPath(indexPath: NSIndexPath) -> LineupCardCell {
        return dequeueReusableCellWithReuseIdentifier(LineupCardCell.reuseIdentifier, forIndexPath: indexPath) as! LineupCardCell
    }
    
    func updateCellTransforms() {
        // Current page can be fractional, i.e. between pages
        let currentPage = contentOffset.x / cardSize.width
        for cell in visibleCells() {
            let cardCell = cell as! LineupCardCell
            let cardPage = CGFloat(indexPathForCell(cardCell)!.item)
            // Page delta is number of pages from perfect center and can be negative
            let pageDelta = cardPage - currentPage
            cardCell.rotate(pageDelta)
            cardCell.fade(abs(pageDelta))
        }
    }
    
    override func touchesShouldCancelInContentView(view: UIView) -> Bool {
        return (view as? CancelableTouchControl)?.touchesShouldCancel ??
            super.touchesShouldCancelInContentView(view)
    }
    
}

// MARK: -

class PaginatedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var pageSize: () -> CGSize = { return CGSizeZero }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let pageWidth = pageSize().width
        let proposedPage = proposedContentOffset.x / pageWidth
        var targetPage = round(proposedPage)
        // Always go at least one page if velocity is non-zero
        if -1.0 <= velocity.x && velocity.x < 0 {
            targetPage = floor(proposedPage)
        } else if 0 < velocity.x && velocity.x <= 1.0 {
            targetPage = ceil(proposedPage)
        }
        return CGPointMake(targetPage * pageWidth, proposedContentOffset.y)
    }
    
}