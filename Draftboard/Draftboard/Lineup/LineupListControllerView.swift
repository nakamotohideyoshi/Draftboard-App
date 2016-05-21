//
//  LineupListControllerView.swift
//  Draftboard
//
//  Created by Anson Schall on 4/6/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class LineupListControllerView: UIView {
    
    let collectionView = LineupCardCollectionView()
    let paginationView = DraftboardPagination()
    let loaderView = LoaderView()
    
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
//        clipsToBounds = true
    }
    
    func addSubviews() {
        addSubview(collectionView)
        addSubview(paginationView)
        addSubview(loaderView)
    }
    
    func addConstraints() {
        paginationHeight = paginationView.heightRancor.constraintEqualToConstant(36.0)
        
        let viewConstraints: [NSLayoutConstraint] = [
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
        ]

        translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        paginationView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func setupSubviews() {
        collectionView.cardInset = UIEdgeInsetsMake(0, 44.0, 0, 44.0)
        
        loaderView.thickness = 2.0
        loaderView.spinning = true
    }
    
    func collectionViewCellForIndexPath(indexPath: NSIndexPath) -> LineupCardCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(LineupCardCell.reuseIdentifier, forIndexPath: indexPath) as! LineupCardCell
    }
    
}