//
//  ContestDetailPrizeCell.swift
//  Draftboard
//
//  Created by devguru on 5/24/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class ContestDetailPrizeCell: DraftboardTableViewCell {

    let rankLabel = DraftboardLabel()
    let priceLabel = DraftboardLabel()
    let borderView = UIView()
    
    var payoutSpot: PayoutSpot? {
        didSet {
            setupPayoutSpot()
        }
    }
    override func setup() {
        addSubviews()
        setupSubviews()
        addConstraints()
    }
    
    func addSubviews() {
        contentView.addSubview(rankLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(borderView)
    }
    
    func setupSubviews() {
        rankLabel.font = .openSans(size: 15)
        rankLabel.textColor = UIColor(0x192436)
        rankLabel.letterSpacing = 0.5
        rankLabel.textAlignment = .Center
        
        priceLabel.font = .oswald(size: 15)
        priceLabel.textColor = UIColor(0x192436)
        priceLabel.letterSpacing = 0.5
        
        borderView.backgroundColor = UIColor(0xe6e8ed)
    }
    
    func addConstraints() {
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewConstraints: [NSLayoutConstraint] = [
            rankLabel.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 20),
            rankLabel.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            priceLabel.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -20),
            priceLabel.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            borderView.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 15),
            borderView.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -15),
            borderView.bottomRancor.constraintEqualToRancor(contentView.bottomRancor),
            borderView.heightRancor.constraintEqualToConstant(fitToPixel(1.0))
        ]
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func setupPayoutSpot() {
        var rank = ""
        if payoutSpot?.rank == 1 {
            rank = "1st"
        } else if payoutSpot?.rank == 2 {
            rank = "2nd"
        } else if payoutSpot?.rank == 3 {
            rank = "3rd"
        } else {
            rank = NSString(format: "%dth", (payoutSpot?.rank)!) as String
        }
        let attributes = [
            NSFontAttributeName: UIFont.openSans(size: 15),
            NSForegroundColorAttributeName: UIColor(0xb0b2c1)
        ]
        let attributedText = NSMutableAttributedString(string: rank + " Place", attributes: attributes)
        attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor(0x192436), range: NSMakeRange(0, 3))
        rankLabel.attributedText = attributedText
        priceLabel.text = payoutSpot?.value.cleanValue
    }

}

extension Double {
    var cleanValue: String {
        return self % 1 == 0 ? String(format: "$%.0f", self) : String(format: "$%.2f", self)
    }
}
