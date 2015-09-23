//
//  ContestsHeaderCell.swift
//  Draftboard
//
//  Created by Karl Weber on 9/23/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable class ContestsHeaderCell: UITableViewHeaderFooterView {

    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var texture: UIImageView!
    
    var nibView: UIView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
