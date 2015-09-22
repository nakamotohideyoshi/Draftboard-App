//
//  DraftboardContestsCell.swift
//  Draftboard
//
//  Created by Karl Weber on 9/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable class DraftboardContestsCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!

    var nibView: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupNib()
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib()
    }
    
    private func setupNib() {
        nibView = self.loadNib()
        nibView.frame = self.bounds
        nibView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(nibView)
        self.awakeFromNib()
    }
    
    internal func loadNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let views = bundle.loadNibNamed(self.nibName(), owner: self, options: nil)
        return views.first as! UIView
    }
    
    internal func nibName() -> String {
        return self.dynamicType.description().componentsSeparatedByString(".").last!
    }

}
