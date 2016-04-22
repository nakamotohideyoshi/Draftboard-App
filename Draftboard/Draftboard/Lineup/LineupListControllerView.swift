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
    let collectionView = LineupCardCollectionView()
    let paginationView = DraftboardPagination()
    let loaderView = LoaderView()
    let createView = UIView()
    
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
        addConstraints()
        setupSubviews()
        clipsToBounds = true
    }
    
    func addSubviews() {
        addSubview(scrollView)
        addSubview(collectionView)
        addSubview(paginationView)
        addSubview(loaderView)
        scrollView.addSubview(createView)
    }
    
    func addConstraints() {
        paginationHeight = paginationView.heightRancor.constraintEqualToConstant(36.0)
        
        let viewConstraints: [NSLayoutConstraint] = [
            scrollView.topRancor.constraintEqualToRancor(topRancor, constant: 76.0),
            scrollView.leftRancor.constraintEqualToRancor(leftRancor, constant: 20.0),
            scrollView.rightRancor.constraintEqualToRancor(rightRancor, constant: -20.0),
            scrollView.bottomRancor.constraintEqualToRancor(paginationView.topRancor),
            
            collectionView.topRancor.constraintEqualToRancor(topRancor, constant: 76.0),
            collectionView.leftRancor.constraintEqualToRancor(leftRancor, constant: -20.0),
            collectionView.rightRancor.constraintEqualToRancor(rightRancor, constant: 20.0),
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
    
    func setupSubviews() {
        scrollView.clipsToBounds = false
        scrollView.pagingEnabled = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.hidden = true
        
        collectionView.cardInset = UIEdgeInsetsMake(0, 44.0, 0, 44.0)
        
        loaderView.thickness = 2.0
        loaderView.spinning = true
        
        createView.backgroundColor = .blueColor()
    }
    
    func collectionViewCellForIndexPath(indexPath: NSIndexPath) -> LineupCardCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(LineupCardCell.reuseIdentifier, forIndexPath: indexPath) as! LineupCardCell
    }
    
}


// MARK: -

class LineupCardCell: UICollectionViewCell {
    
    static let reuseIdentifier = "LineupCardCell"
    
    let lineupView = UIView()
    let createView = UIView()
    
    var lineup: Lineup? {
        didSet {
            let lineupExists = (lineup != nil)
            lineupView.hidden = !lineupExists
            createView.hidden = lineupExists
        }
    }
    
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
    
    func setup() {
        addSubviews()
        addConstraints()
        setupSubviews()
    }
    
    func addSubviews() {
        contentView.addSubview(lineupView)
        contentView.addSubview(createView)
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            contentView.topRancor.constraintEqualToRancor(topRancor),
            contentView.leftRancor.constraintEqualToRancor(leftRancor),
            contentView.rightRancor.constraintEqualToRancor(rightRancor),
            contentView.bottomRancor.constraintEqualToRancor(bottomRancor),
            
            lineupView.topRancor.constraintEqualToRancor(contentView.topRancor, constant: 2.0),
            lineupView.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 2.0),
            lineupView.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -2.0),
            lineupView.bottomRancor.constraintEqualToRancor(contentView.bottomRancor, constant: -2.0),
            
            createView.topRancor.constraintEqualToRancor(contentView.topRancor, constant: 2.0),
            createView.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 2.0),
            createView.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -2.0),
            createView.bottomRancor.constraintEqualToRancor(contentView.bottomRancor, constant: -2.0),
        ]
        
        translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        lineupView.translatesAutoresizingMaskIntoConstraints = false
        createView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func setupSubviews() {
        contentView.backgroundColor = .clearColor()
        lineupView.backgroundColor = .whiteColor()
        createView.backgroundColor = .blueMediumDark()
        lineupView.layer.allowsEdgeAntialiasing = true
        createView.layer.allowsEdgeAntialiasing = true
    }

    func fade(amount: CGFloat) {
        alpha = 1.0 - (amount * 0.5)
    }
    
    func rotate(amount: CGFloat) {
        let direction: CGFloat = (amount < 0) ? -1 : 1
        let magnitude: CGFloat = abs(amount)
        var (integral, fraction) = modf(magnitude)
        let translateX = direction * (bounds.width / 2)
        let rotateY = direction * CGFloat(M_PI_4)
        let scale = 1.0 - (magnitude * 0.025)
        
        var t = CATransform3DIdentity
        t = CATransform3DTranslate(t, -translateX * integral * 2, 0, 0)
        
        t = CATransform3DTranslate(t, -translateX, 0, 0)
        t = CATransform3DRotate(t, rotateY * fraction, 0, 1, 0)
        t = CATransform3DTranslate(t, translateX, 0, 0)
        
        while integral > 0 {
            t = CATransform3DTranslate(t, translateX, 0, 0)
            t = CATransform3DRotate(t, rotateY, 0, 1, 0)
            t = CATransform3DTranslate(t, translateX, 0, 0)
            integral -= 1
        }
        
        t = CATransform3DScale(t, scale, scale, 1)

        layer.transform = t
        
        // A different approach for a similar effect
        /*
        let translateX = -amount * bounds.width
        let translateZ = -1.207 * bounds.width
        let rotateY = amount * CGFloat(M_PI_4)
        let scale = 1.0 - (abs(amount) * 0.025)

        var t = CATransform3DIdentity
        t = CATransform3DTranslate(t, translateX, 0, 0) // reset to viewport center
        t = CATransform3DTranslate(t, 0, 0, translateZ) // push to carousel center
        t = CATransform3DRotate(t, rotateY, 0, 1, 0) // rotate at carousel center
        t = CATransform3DTranslate(t, 0, 0, -translateZ) // push back toward viewport
        // scale down as distance from viewport center increases
        t = CATransform3DScale(t, scale, scale, 1.0)

        layer.transform = t
        */
    }
    
}

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
    
    func dequeueCellForIndexPath(indexPath: NSIndexPath) -> LineupCardCell {
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