//
//  CellOne.swift
//  RedMesa
//
//  Created by Karl Weber on 9/9/15.
//  Copyright (c) 2015 Rally Interactive. All rights reserved.
//

import UIKit

class CellOne: UICollectionViewCell, UIGestureRecognizerDelegate {

    var titleLabel: UILabel = UILabel()
    var subLabel: UILabel = UILabel()
    var lineView: UIView = UIView()
    var lineWidth: CGFloat = 0.0
    let leftMargin: CGFloat = 24.0
    let veritcalMargins: CGFloat = 20.0
    let fontSize: CGFloat = 13.0
    let subFontSize: CGFloat = 13.0
    
    var squareView: UIView = UIView()
    var leftSwipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    var rightSwipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    
    var buttonsExposed: Bool = false
    
    var parentCollectionView: UICollectionView?
    var currentIndexPath: NSIndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        lineWidth = contentView.frame.width - leftMargin
        self.backgroundColor = .whiteColor()
        
        titleLabel = UILabel(frame: CGRectMake(leftMargin, veritcalMargins, self.bounds.size.width, 16.0))
        titleLabel.autoresizingMask = .FlexibleWidth
        titleLabel.font = .systemFontOfSize(fontSize)
        titleLabel.textColor = .draftColorTextBlue()
        titleLabel.textAlignment = .Left
        contentView.addSubview(titleLabel)
        
        subLabel = UILabel(frame: CGRectMake(leftMargin, self.bounds.size.height-veritcalMargins-subFontSize, self.bounds.size.width, 13.0))
        subLabel.autoresizingMask = .FlexibleWidth
        subLabel.font = .systemFontOfSize(subFontSize)
        subLabel.textColor = .draftColorTextLightBlue()
        subLabel.textAlignment = .Left
        contentView.addSubview(subLabel)
        
        lineView.frame = CGRectMake(leftMargin, contentView.frame.height - 1, lineWidth, 0.5)
        lineView.backgroundColor = .draftColorDividerLightBlue()
        contentView.addSubview(lineView)
        
        squareView.backgroundColor = .blueColor()
        squareView.frame = CGRectMake(contentView.frame.size.width, contentView.frame.origin.y, contentView.frame.size.width, contentView.frame.size.height)
        contentView.addSubview(squareView)
        
        // react to swiping.
        leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "didSwipeLeft:")
        leftSwipeGestureRecognizer.direction = .Left
        leftSwipeGestureRecognizer.delegate = self
        self.contentView.addGestureRecognizer(leftSwipeGestureRecognizer)
        
        
        rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "didSwipeRight:")
        rightSwipeGestureRecognizer.direction = .Right
        rightSwipeGestureRecognizer.delegate = self
        self.contentView.addGestureRecognizer(rightSwipeGestureRecognizer)
        
//        [self.tapGestureRecognizer requireGestureRecognizerToFail:_containingTableView.panGestureRecognizer];
    }
    
    func setContainingCollectionView(collectionView: UICollectionView) {
        self.parentCollectionView = collectionView
//        let parentRecognizer: UIPanGestureRecognizer = collectionView.panGestureRecognizer
//        swiperGestureRecognizer.requireGestureRecognizerToFail(parentRecognizer)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        lineWidth = contentView.frame.width - leftMargin
        titleLabel.frame = CGRectMake(leftMargin, veritcalMargins, self.bounds.size.width, 16.0)
        subLabel.frame = CGRectMake(leftMargin, self.bounds.size.height-veritcalMargins-fontSize, self.bounds.size.width, 13.0)
        lineView.frame = CGRectMake(leftMargin, self.bounds.size.height - 1, lineWidth, 0.5)
        
        if buttonsExposed {
            squareView.frame = CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y, contentView.frame.size.width, contentView.frame.size.height)
        } else {
            squareView.frame = CGRectMake(contentView.frame.size.width, contentView.frame.origin.y, contentView.frame.size.width, contentView.frame.size.height)
        }
    }
    
    func didSwipeLeft(gestureRecognizer: UISwipeGestureRecognizer) {
        if buttonsExposed == false {
            buttonsExposed = true
            squareView.frame = CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y, contentView.frame.size.width, contentView.frame.size.height)
        }
    }
    
    func didSwipeRight(gestureRecognizer: UISwipeGestureRecognizer) {
        if buttonsExposed {
            buttonsExposed = false
            squareView.frame = CGRectMake(contentView.frame.size.width, contentView.frame.origin.y, contentView.frame.size.width, contentView.frame.size.height)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touches ended")
    }
}
