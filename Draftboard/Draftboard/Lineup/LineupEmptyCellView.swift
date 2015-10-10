//
//  LineupEmptyCellView.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/15/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class LineupEmptyCellView: DraftboardNibView {
    @IBOutlet weak var bottomBorderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topBorderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var abbrvLabel: DraftboardLabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var bottomBorderView: UIView!
    @IBOutlet weak var topBorderView: UIView!
    @IBOutlet weak var positionLabel: DraftboardLabel!
    
    override func willAwakeFromNib() {
        nibView.backgroundColor = .clearColor()
        bottomBorderView.hidden = true
        topBorderHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
        bottomBorderHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
    }
    
    @IBInspectable var topBorder: Bool = true {
        didSet {
            topBorderView.hidden = !topBorder
        }
    }
    
    @IBInspectable var bottomBorder: Bool = false {
        didSet {
            bottomBorderView.hidden = !bottomBorder
        }
    }
    
    @IBInspectable var positionText: String = "Forward" {
        didSet {
            positionLabel.text = positionText
        }
    }
    
    @IBInspectable var abbrvText: String = "F" {
        didSet {
            abbrvLabel.text = abbrvText
        }
    }
    
    @IBInspectable var avatarImage: UIImage? {
        didSet {
            avatarImageView.image = avatarImage
        }
    }
}