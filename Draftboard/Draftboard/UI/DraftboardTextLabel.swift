//
//  DraftboardTextLabel.swift
//  Draftboard
//
//  Created by Anson Schall on 9/14/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardTextLabel: UILabel {
    
    private var attributes: [String: AnyObject] = [:]
    override var text: String? { didSet { updateAttributedText() } }
    var kern: CGFloat? { didSet { updateAttributedText() } }
    
    func updateAttributedText() {
        if let kern = kern {
            attributes[NSKernAttributeName] = kern
        }
        attributedText = NSMutableAttributedString(string: text ?? "", attributes: attributes)
    }
    
}

