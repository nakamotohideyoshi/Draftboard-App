//
//  CellOne.swift
//  RedMesa
//
//  Created by Karl Weber on 9/9/15.
//  Copyright (c) 2015 Rally Interactive. All rights reserved.
//

import UIKit

class CellOne: UICollectionViewCell {

    var imageView: UIImageView = UIImageView()
    var titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFill
        self.contentView.addSubview(imageView)
        
        titleLabel = UILabel(frame: CGRectMake(0.0, self.bounds.size.height-50.0, self.bounds.size.width, 40.0))
        titleLabel.autoresizingMask = .FlexibleWidth
        titleLabel.textAlignment = .Center
//        titleLabel.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        titleLabel.font = .systemFontOfSize(20.0)
        titleLabel.textColor = .whiteColor()
        self.contentView.addSubview(titleLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        imageView.frame = self.bounds
    }
    
}
