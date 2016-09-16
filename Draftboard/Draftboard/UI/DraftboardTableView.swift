//
//  DraftboardTableView.swift
//  Draftboard
//
//  Created by Anson Schall on 9/15/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

// See also: DraftboardView
class DraftboardTableView: UITableView {
    
    var wrapperView: UIView?
    
    init() {
        super.init(frame: CGRectZero, style: .Plain)
        setup()
    }
    
    convenience init(frame: CGRect) {
        self.init()
        self.frame = frame
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    func setup() {
        // Override and call super.setup()
        separatorStyle = .None
        
        // Expose private views
        if let wrapperClass = NSClassFromString("UITableView" + "WrapperView") {
            wrapperView = subviews.filter { $0.isKindOfClass(wrapperClass) }.first
        }

    }
    
}
