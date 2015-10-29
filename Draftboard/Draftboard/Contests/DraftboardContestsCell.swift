//
//  DraftboardContestsCell.swift
//  Draftboard
//
//  Created by Karl Weber on 9/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardContestsCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var sportImage: UIImageView!
    @IBOutlet weak var guaranteedLabel: DraftboardLabel!
    @IBOutlet weak var moneyBar: MoneyBar!
    @IBOutlet weak var entryNumbers: UILabel!
    
    override func awakeFromNib() {
//        lineView.backgroundColor = UIColor(red: 0.901, green: 0.909, blue: 0.929, alpha: 0.1)
//        title.textColor = .whiteColor()
//        subtitle.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
//        entryNumbers.textColor = .whiteColor()
//        entryNumbers.text = ""
//        contentView.backgroundColor = UIColor(red: 0.0549, green: 0.0901, blue: 0.137, alpha: 0.65)
//        backgroundColor = UIColor.clearColor()
//        sportImage.tintColor = UIColor(red: 0.69, green: 0.698, blue: 0.756, alpha: 1)
//        setNotGuaranteed()
    }
    
    func setEntries(number: Int) {
//        entryNumbers.textColor = UIColor.moneyGreen()
//        entryNumbers.text = "\(number)"
//        sportImage.tintColor = UIColor.moneyGreen()
    }
    
    func noEntries() {
//        entryNumbers.textColor = .whiteColor()
//        entryNumbers.text = ""
//        sportImage.tintColor = .whiteColor()
    }
    
    func setGuaranteed() {
//        guaranteedLabel.backgroundColor = .moneyGreen()
//        guaranteedLabel.text = "G"
    }
    
    func setNotGuaranteed() {
//        guaranteedLabel.backgroundColor = .clearColor()
//        guaranteedLabel.text = ""
    }
}
