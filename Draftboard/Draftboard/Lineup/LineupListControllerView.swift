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
    let paginationView = DraftboardPagination()
    let loaderView = LoaderView()
    let createView = UIView()
    
    var paginationHeight: NSLayoutConstraint!
    
    // MARK: Init
    
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
    
    // MARK: Setup
    
    func setup() {
        addSubviews()
        setupSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(scrollView)
        addSubview(paginationView)
        addSubview(loaderView)
        scrollView.addSubview(createView)
    }
    
    func setupSubviews() {
        scrollView.clipsToBounds = false
        scrollView.pagingEnabled = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.showsHorizontalScrollIndicator = false
   
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
        paginationView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        createView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
}
