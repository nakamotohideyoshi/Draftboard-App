//
//  HeaderViewOne.swift
//  RedMesa
//
//  Created by Karl Weber on 9/9/15.
//  Copyright (c) 2015 Rally Interactive. All rights reserved.
//

import UIKit

class HeaderViewOne: UICollectionViewCell {
    
    var titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel(frame: CGRectMake(0.0, 0.0, 60.0, 40.0))
        titleLabel.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont.systemFontOfSize(8.0)
        titleLabel.textColor = .blackColor()
        contentView.addSubview(titleLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
    }
    
}
