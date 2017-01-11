//
//  LayoutRancor.swift
//  Draftboard
//
//  Created by Anson Schall on 9/14/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LayoutRancor : NSObject {
    
    var view: UIView
    var attribute: NSLayoutAttribute
    
    init(view: UIView, attribute: NSLayoutAttribute) {
        self.view = view
        self.attribute = attribute
    }
    
    func constraintEqualToRancor(rancor: LayoutRancor!) -> NSLayoutConstraint! {
        return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .Equal, toItem: rancor.view, attribute: rancor.attribute, multiplier: 1, constant: 0)
    }
    
    func constraintEqualToRancor(rancor: LayoutRancor!, constant: CGFloat) -> NSLayoutConstraint! {
        return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .Equal, toItem: rancor.view, attribute: rancor.attribute, multiplier: 1, constant: constant)
    }
    
}

class LayoutDementia : LayoutRancor {
    
    func constraintEqualToConstant(constant: CGFloat) -> NSLayoutConstraint! {
        return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: constant)
    }
    
    func constraintEqualToRancor(rancor: LayoutDementia!, multiplier: CGFloat) -> NSLayoutConstraint! {
        return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .Equal, toItem: rancor.view, attribute: rancor.attribute, multiplier: multiplier, constant: 0)
    }

    func constraintEqualToRancor(rancor: LayoutDementia!, multiplier: CGFloat, constant: CGFloat) -> NSLayoutConstraint! {
        return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .Equal, toItem: rancor.view, attribute: rancor.attribute, multiplier: multiplier, constant: constant)
    }
    
}

extension UIView {
    
    var leadingRancor : LayoutRancor {
        get { return LayoutRancor(view: self, attribute: .Leading) }
    }
    
    var trailingRancor: LayoutRancor {
        get { return LayoutRancor(view: self, attribute: .Trailing) }
    }
    
    var leftRancor: LayoutRancor {
        get { return LayoutRancor(view: self, attribute: .Left) }
    }
    
    var rightRancor: LayoutRancor {
        get { return LayoutRancor(view: self, attribute: .Right) }
    }
    
    var topRancor: LayoutRancor {
        get { return LayoutRancor(view: self, attribute: .Top) }
    }
    
    var bottomRancor: LayoutRancor {
        get { return LayoutRancor(view: self, attribute: .Bottom) }
    }
    
    var widthRancor: LayoutDementia {
        get { return LayoutDementia(view: self, attribute: .Width) }
    }
    
    var heightRancor: LayoutDementia {
        get { return LayoutDementia(view: self, attribute: .Height) }
    }
    
    var centerXRancor: LayoutRancor {
        get { return LayoutRancor(view: self, attribute: .CenterX) }
    }
    
    var centerYRancor: LayoutRancor {
        get { return LayoutRancor(view: self, attribute: .CenterY) }
    }
    
    var baseLineRancor: LayoutRancor {
        get { return LayoutRancor(view: self, attribute: .LastBaseline) }
    }
    
}
