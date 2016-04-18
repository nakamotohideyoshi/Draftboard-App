//
//  LineupListControllerView.swift
//  Draftboard
//
//  Created by Anson Schall on 4/6/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class LineupListControllerView: UIView {
    
    let scrollView = UIScrollView()
    let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewLayout())
    let paginationView = DraftboardPagination()
    let loaderView = LoaderView()
    let createView = UIView()
    
    let cardInset = UIEdgeInsetsMake(0, 20.0, 0, 20.0)
    var cardSize: CGSize { return UIEdgeInsetsInsetRect(collectionView.frame, cardInset).size }
    var paginationHeight: NSLayoutConstraint!
    
    // MARK: -
    
    init() {
        super.init(frame: CGRectZero)
        setup()
    }
    
    override convenience init(frame: CGRect) {
        self.init()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    // MARK: -
    
    func setup() {
        addSubviews()
        setupSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(scrollView)
        addSubview(collectionView)
        addSubview(paginationView)
        addSubview(loaderView)
        scrollView.addSubview(createView)
    }
    
    func setupSubviews() {
        scrollView.clipsToBounds = false
        scrollView.pagingEnabled = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.hidden = true

        let layout = PaginatedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.pageSize = { return self.cardSize }
        layout.scrollDirection = .Horizontal
        layout.sectionInset = UIEdgeInsetsMake(0, cardInset.left, 0, 0)
        collectionView.alwaysBounceHorizontal = true
        collectionView.backgroundColor = .clearColor()
        collectionView.collectionViewLayout = layout
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, cardInset.right)
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.registerClass(LineupCardCell.self, forCellWithReuseIdentifier: LineupCardCell.reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
   
        loaderView.thickness = 2.0
        loaderView.spinning = true
        
        createView.backgroundColor = .blueColor()
    }
    
    func setupConstraints() {
        paginationHeight = paginationView.heightRancor.constraintEqualToConstant(36.0)
        
        let viewConstraints: [NSLayoutConstraint] = [
            scrollView.topRancor.constraintEqualToRancor(topRancor, constant: 76.0),
            scrollView.leftRancor.constraintEqualToRancor(leftRancor, constant: 20.0),
            scrollView.rightRancor.constraintEqualToRancor(rightRancor, constant: -20.0),
            scrollView.bottomRancor.constraintEqualToRancor(paginationView.topRancor),
            
            collectionView.topRancor.constraintEqualToRancor(topRancor, constant: 76.0),
            collectionView.leftRancor.constraintEqualToRancor(leftRancor),
            collectionView.rightRancor.constraintEqualToRancor(rightRancor),
            collectionView.bottomRancor.constraintEqualToRancor(paginationView.topRancor),
            
            paginationView.leftRancor.constraintEqualToRancor(leftRancor),
            paginationView.rightRancor.constraintEqualToRancor(rightRancor),
            paginationView.bottomRancor.constraintEqualToRancor(bottomRancor),
            paginationHeight,
            
            loaderView.widthRancor.constraintEqualToConstant(42.0),
            loaderView.heightRancor.constraintEqualToConstant(42.0),
            loaderView.centerXRancor.constraintEqualToRancor(centerXRancor),
            loaderView.centerYRancor.constraintEqualToRancor(centerYRancor),
            
            createView.topRancor.constraintEqualToRancor(scrollView.topRancor),
            createView.leftRancor.constraintEqualToRancor(scrollView.leftRancor),
            createView.widthRancor.constraintEqualToRancor(scrollView.widthRancor),
            createView.heightRancor.constraintEqualToRancor(scrollView.heightRancor),
        ]

        translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        paginationView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        createView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
}

extension LineupListControllerView {
    
    func collectionViewCellForIndexPath(indexPath: NSIndexPath) -> LineupCardCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(LineupCardCell.reuseIdentifier, forIndexPath: indexPath) as! LineupCardCell
    }
    
}

// MARK: -

class LineupCardCell: UICollectionViewCell {
    
    static let reuseIdentifier = "LineupCardCell"
    
    var lineup: Lineup!
    
}

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