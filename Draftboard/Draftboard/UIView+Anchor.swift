//
//  UIView+Anchor.swift
//  Draftboard
//
//  Created by Anson Schall on 9/14/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class Anchor {
    
    var view: UIView
    var attribute: NSLayoutAttribute
    
    init(view: UIView, attribute: NSLayoutAttribute) {
        self.view = view
        self.attribute = attribute
    }
    
    func constraintEqualTo(anchor: Anchor, constant: CGFloat? = 0) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.view, attribute: self.attribute, relatedBy: .Equal, toItem: anchor.view, attribute: anchor.attribute, multiplier: 1, constant: constant!)
    }
    
}

class Dimension : Anchor {
    
    func constraintEqualTo(dimension: Dimension, multiplier: CGFloat? = 1, constant: CGFloat? = 0) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.view, attribute: self.attribute, relatedBy: .Equal, toItem: dimension.view, attribute: dimension.attribute, multiplier: multiplier!, constant: constant!)
    }

    func constraintEqualTo(constant: CGFloat) -> NSLayoutConstraint! {
        return NSLayoutConstraint(item: self.view, attribute: self.attribute, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: constant)
    }
    
}

extension UIView {
    
    var leading : Anchor {
        get { return Anchor(view: self, attribute: .Leading) }
    }
    
    var trailing: Anchor {
        get { return Anchor(view: self, attribute: .Trailing) }
    }
    
    var left: Anchor {
        get { return Anchor(view: self, attribute: .Left) }
    }
    
    var right: Anchor {
        get { return Anchor(view: self, attribute: .Right) }
    }
    
    var top: Anchor {
        get { return Anchor(view: self, attribute: .Top) }
    }
    
    var bottom: Anchor {
        get { return Anchor(view: self, attribute: .Bottom) }
    }
    
    var width: Dimension {
        get { return Dimension(view: self, attribute: .Width) }
    }
    
    var height: Dimension {
        get { return Dimension(view: self, attribute: .Height) }
    }
    
    var centerX: Anchor {
        get { return Anchor(view: self, attribute: .CenterX) }
    }
    
    var centerY: Anchor {
        get { return Anchor(view: self, attribute: .CenterY) }
    }
    
    var baseline: Anchor {
        get { return Anchor(view: self, attribute: .Baseline) }
    }
    
}
