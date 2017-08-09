//
//  DraftboardModalItemView.swift
//  Draftboard
//
//  Created by Wes Pearce on 11/4/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardModalItemView: DraftboardNibControl {
    var titleText: String = ""
    var subtitleText: String = ""
    
    @IBOutlet weak var titleLabel: DraftboardLabel!
    @IBOutlet weak var subtitleLabel: DraftboardLabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var iconArrow: UIImageView!
    @IBOutlet weak var iconEdit: UIImageView!
    
    var index: Int!
    
    init(title: String, subtitle: String) {
        super.init(frame: CGRectZero)
        titleText = title
        subtitleText = subtitle
        self.setupNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib()
    }
    
    override func willAwakeFromNib() {
        
        let tintColor = iconArrow.tintColor
        iconArrow.tintColor = nil
        iconArrow.tintColor = tintColor
        iconEdit.tintColor = nil
        iconEdit.tintColor = tintColor
        
        titleLabel.text = titleText.uppercaseString
        subtitleLabel.text = subtitleText.uppercaseString
        _selectedView = selectedView
    }
}
