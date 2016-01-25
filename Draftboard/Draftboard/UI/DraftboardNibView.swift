//
//  DraftboardNibView.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/16/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardNibView: UIView {
    var nibView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib()
    }
    
    func setupNib() {
        nibView = self.loadNib()
        nibView.frame = self.bounds
        nibView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        self.addSubview(nibView)
        self.willAwakeFromNib()
    }
    
    func willAwakeFromNib() {
        // subclass
    }
    
    func loadNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        
        let nibName = self.nibName()
        var nib = App.nibCache[nibName]
        
        if nib == nil {
            nib = UINib(nibName: nibName, bundle: bundle)
            App.nibCache[nibName] = nib
        }
        
        let views = nib!.instantiateWithOwner(self, options: nil)
        return views.first as! UIView
    }
    
    func nibName() -> String {
        return self.dynamicType.description().componentsSeparatedByString(".").last!
    }
}
