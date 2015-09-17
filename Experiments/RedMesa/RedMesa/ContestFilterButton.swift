//
//  ContestFilterButton.swift
//  RedMesa
//
//  Created by Karl Weber on 9/11/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class ContestFilterButton: UICollectionViewCell {

    var filterButton: UIButton = UIButton()
    let fontSize: CGFloat = 16.0
    var stickyRect: CGRect = CGRectZero

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .clearColor()

        filterButton = UIButton(frame: CGRectMake(0.0, 0.0, frame.size.width, 50.0))
        filterButton.setTitle("hello", forState: .Normal)
        filterButton.autoresizingMask = .FlexibleWidth
        filterButton.titleLabel!.font = .systemFontOfSize(fontSize)
        filterButton.titleLabel!.textColor = .whiteColor()
        filterButton.titleLabel!.textAlignment = .Center
        filterButton.backgroundColor = UIColor.draftColorDarkBlue()
        contentView.addSubview(filterButton)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        filterButton.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, 50.0)
    }

}
