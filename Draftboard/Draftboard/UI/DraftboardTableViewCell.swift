//
//  DraftboardTableViewCell.swift
//  Draftboard
//
//  Created by Anson Schall on 8/1/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardTableViewCell: UITableViewCell {
    
    init(reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    override convenience init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.init(reuseIdentifier: reuseIdentifier)
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    func setup() {
        // Override and call super.setup()
        layer.rasterizationScale = UIScreen.mainScreen().scale
        backgroundColor = .clearColor()
        selectionStyle = .None
    }

}
