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
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var sportImage: UIImageView!
    @IBOutlet weak var entryNumbers: UILabel!
    @IBOutlet weak var guaranteedLabel: DraftboardLabel!

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
        self.contentView.addSubview(nibView)
        lineView.backgroundColor = UIColor(red: 0.901, green: 0.909, blue: 0.929, alpha: 0.1)
        title.textColor = .whiteColor()
        subtitle.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        entryNumbers.textColor = .whiteColor()
        entryNumbers.text = ""
        contentView.backgroundColor = UIColor(red: 0.0549, green: 0.0901, blue: 0.137, alpha: 0.65)
        backgroundColor = UIColor.clearColor()
        sportImage.tintColor = UIColor(red: 0.69, green: 0.698, blue: 0.756, alpha: 1)
        setNotGuaranteed()
        
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
    
    func setEntries(number: Int) {
        entryNumbers.textColor = UIColor.funkyGreen()
        entryNumbers.text = "\(number)"
        sportImage.tintColor = UIColor.funkyGreen()
    }
    
    func noEntries() {
        entryNumbers.textColor = .whiteColor()
        entryNumbers.text = ""
        sportImage.tintColor = .whiteColor()
    }
    
    func setGuaranteed() {
        guaranteedLabel.backgroundColor = .funkyGreen()
        guaranteedLabel.text = "G"
    }
    
    func setNotGuaranteed() {
        guaranteedLabel.backgroundColor = .clearColor()
        guaranteedLabel.text = ""
    }

}
