//
//  LineupEmptyCellView.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/15/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable class LineupEmptyCellView: UIView {

    @IBOutlet weak var abbrvLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var bottomBorderView: UIView!
    @IBOutlet weak var topBorderView: UIView!
    @IBOutlet weak var positionLabel: UILabel!
    
    var view : UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    func setup() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "LineupEmptyCellView", bundle: bundle)
        
        view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.left.constraintEqualTo(self.left).active = true
        view.top.constraintEqualTo(self.top).active = true
        view.bottom.constraintEqualTo(self.bottom).active = true
        view.right.constraintEqualTo(self.right).active = true
        
        bottomBorderView.hidden = true
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