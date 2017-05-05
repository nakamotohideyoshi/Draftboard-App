//
//  PlayerReportCell.swift
//  Draftboard
//
//  Created by devguru on 5/4/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class PlayerReportCell: UITableViewCell {
    
    let timeLabel = UILabel()
    let byLabel = UILabel()
    let logoImage = UIImageView()
    let titleLabel1 = UILabel()
    let contentLabel1 = UILabel()
    let titleLabel2 = UILabel()
    let contentLabel2 = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    func setup() {
        addSubviews()
        setupSubviews()
        addConstraints()
    }
    
    func addSubviews() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(byLabel)
        contentView.addSubview(logoImage)
        contentView.addSubview(titleLabel1)
        contentView.addSubview(contentLabel1)
        contentView.addSubview(titleLabel2)
        contentView.addSubview(contentLabel2)
    }
    
    func setupSubviews() {
        timeLabel.font = .openSans(size: 11.0)
        timeLabel.textColor = UIColor(0xb0b2c1)
        timeLabel.text = "a day ago"
        timeLabel.numberOfLines = 0
        
        byLabel.font = .openSans(size: 7.0)
        byLabel.textColor = UIColor(0xb0b2c1)
        byLabel.text = "BY"
        
        logoImage.image = UIImage(named: "logo-rotowire")
        logoImage.contentMode = .ScaleAspectFit
        
        titleLabel1.font = .openSans(weight: .Bold, size: 12)
        titleLabel1.textColor = UIColor(0x46495e)
        titleLabel1.numberOfLines = 0
        
        contentLabel1.font = .openSans(size: 12)
        contentLabel1.textColor = UIColor(0x6d718a)
        contentLabel1.numberOfLines = 0
        
        titleLabel2.font = .openSans(weight: .Bold, size: 12)
        titleLabel2.textColor = UIColor(0x46495e)
        titleLabel2.numberOfLines = 0
        
        contentLabel2.font = .openSans(size: 12)
        contentLabel2.textColor = UIColor(0x6d718a)
        contentLabel2.numberOfLines = 0
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            timeLabel.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 15),
            timeLabel.topRancor.constraintEqualToRancor(contentView.topRancor),
            timeLabel.bottomRancor.constraintEqualToRancor(titleLabel1.topRancor, constant: -5),
            titleLabel1.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 15),
            titleLabel1.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -15),
            titleLabel1.bottomRancor.constraintEqualToRancor(contentLabel1.topRancor, constant: -5),
            contentLabel1.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 15),
            contentLabel1.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -15),
            contentLabel1.bottomRancor.constraintEqualToRancor(titleLabel2.topRancor, constant: -20),
            titleLabel2.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 15),
            titleLabel2.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -15),
            titleLabel2.bottomRancor.constraintEqualToRancor(contentLabel2.topRancor, constant: -5),
            contentLabel2.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 15),
            contentLabel2.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -15),
            contentLabel2.bottomRancor.constraintEqualToRancor(contentView.bottomRancor, constant: -15),
            byLabel.leftRancor.constraintEqualToRancor(timeLabel.rightRancor, constant: 5),
            byLabel.topRancor.constraintEqualToRancor(timeLabel.topRancor, constant: fitToPixel(timeLabel.font.ascender - byLabel.font.ascender)),
            logoImage.widthRancor.constraintEqualToConstant(51),
            logoImage.heightRancor.constraintEqualToConstant(17),
            logoImage.leftRancor.constraintEqualToRancor(byLabel.rightRancor, constant: 5),
            logoImage.topRancor.constraintEqualToRancor(timeLabel.topRancor),
        ]
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        byLabel.translatesAutoresizingMaskIntoConstraints = false
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        titleLabel1.translatesAutoresizingMaskIntoConstraints = false
        contentLabel1.translatesAutoresizingMaskIntoConstraints = false
        titleLabel2.translatesAutoresizingMaskIntoConstraints = false
        contentLabel2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }

    
    override func layoutSubviews() {
        //let timeLabelSize = timeLabel.sizeThatFits(CGSizeZero)
        
        //timeLabel.frame = CGRectMake(15, 0, timeLabelSize.width, timeLabelSize.height)
    }
}

