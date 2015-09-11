//
//  Constraint.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/11/15.
//  Copyright (c) 2015 Rally Interactive. All rights reserved.
//

import UIKit

struct LayoutAttribute : OptionSetType {
    let rawValue: Int
    static let None = LayoutAttribute(rawValue: 0)
    static let Left = LayoutAttribute(rawValue: 1 << 0)
    static let Right = LayoutAttribute(rawValue: 1 << 1)
    static let Top = LayoutAttribute(rawValue: 1 << 2)
    static let Bottom = LayoutAttribute(rawValue: 1 << 3)
    static let Leading = LayoutAttribute(rawValue: 1 << 4)
    static let Trailing = LayoutAttribute(rawValue: 1 << 5)
    static let Width = LayoutAttribute(rawValue: 1 << 6)
    static let Height = LayoutAttribute(rawValue: 1 << 7)
    static let CenterX = LayoutAttribute(rawValue: 1 << 8)
    static let CenterY = LayoutAttribute(rawValue: 1 << 9)
}

class Constraint {
    
    class func make(firstItem: AnyObject, _ firstAttribute: NSLayoutAttribute, _ relation: NSLayoutRelation, _ secondItem: AnyObject?, _ secondAttribute: NSLayoutAttribute, _ constant: CGFloat, _ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: firstItem, attribute: firstAttribute, relatedBy: relation, toItem: secondItem, attribute: secondAttribute, multiplier: multiplier, constant: constant)
    }
    
    class func make(firstItem: AnyObject, _ firstAttribute: NSLayoutAttribute, _ relation: NSLayoutRelation, _ secondItem: AnyObject?, _ secondAttribute: NSLayoutAttribute, _ constant: CGFloat) -> NSLayoutConstraint {
        return Constraint.make(firstItem, firstAttribute, relation, secondItem, secondAttribute, constant, 1.0)
    }
    
    class func make(firstItem: AnyObject, _ firstAttribute: NSLayoutAttribute, _ relation: NSLayoutRelation, _ secondItem: AnyObject?, _ secondAttribute: NSLayoutAttribute) -> NSLayoutConstraint {
        return Constraint.make(firstItem, firstAttribute, relation, secondItem, secondAttribute, 0.0)
    }
    
    class func make(firstItem: AnyObject, _ firstAttribute: NSLayoutAttribute, _ relation: NSLayoutRelation, _ secondItem: AnyObject?) -> NSLayoutConstraint {
        return Constraint.make(firstItem, firstAttribute, relation, secondItem, firstAttribute)
    }
    
    // Special cases for "equal"
    
    class func makeEq(firstItem: AnyObject, _ secondItem: AnyObject?, _ attribute: NSLayoutAttribute, _ constant: CGFloat, _ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: firstItem, attribute: attribute, relatedBy: .Equal, toItem: secondItem, attribute: attribute, multiplier: multiplier, constant: constant)
    }
    
    class func makeEq(firstItem: AnyObject, _ secondItem: AnyObject?, _ attribute: NSLayoutAttribute, _ constant: CGFloat) -> NSLayoutConstraint {
        return Constraint.makeEq(firstItem, secondItem, attribute, constant, 1.0)
    }
    
    class func makeEq(firstItem: AnyObject, _ secondItem: AnyObject?, _ attribute: NSLayoutAttribute) -> NSLayoutConstraint {
        return Constraint.makeEq(firstItem, secondItem, attribute, 0.0)
    }
    
    // Multiple constraints at once
    
    class func makeEq(firstItem: AnyObject, _ secondItem: AnyObject?, _ attributes: LayoutAttribute, _ constant: CGFloat, _ multiplier: CGFloat) -> [NSLayoutConstraint] {
        var c = [NSLayoutConstraint]()
        
        if (attributes.contains(.Left)) {
            c.append(Constraint.makeEq(firstItem, secondItem, .Left, constant, multiplier))
        }
        if (attributes.contains(.Right)) {
            c.append(Constraint.makeEq(firstItem, secondItem, .Right, constant, multiplier))
        }
        if (attributes.contains(.Top)) {
            c.append(Constraint.makeEq(firstItem, secondItem, .Top, constant, multiplier))
        }
        if (attributes.contains(.Bottom)) {
            c.append(Constraint.makeEq(firstItem, secondItem, .Bottom, constant, multiplier))
        }
        if (attributes.contains(.Leading)) {
            c.append(Constraint.makeEq(firstItem, secondItem, .Leading, constant, multiplier))
        }
        if (attributes.contains(.Trailing)) {
            c.append(Constraint.makeEq(firstItem, secondItem, .Trailing, constant, multiplier))
        }
        if (attributes.contains(.Width)) {
            c.append(Constraint.makeEq(firstItem, secondItem, .Width, constant, multiplier))
        }
        if (attributes.contains(.Height)) {
            c.append(Constraint.makeEq(firstItem, secondItem, .Height, constant, multiplier))
        }
        if (attributes.contains(.CenterX)) {
            c.append(Constraint.makeEq(firstItem, secondItem, .CenterX, constant, multiplier))
        }
        if (attributes.contains(.CenterY)) {
            c.append(Constraint.makeEq(firstItem, secondItem, .CenterY, constant, multiplier))
        }
        
        return c
    }
    
    class func makeEq(firstItem: AnyObject, _ secondItem: AnyObject?, _ attributes: LayoutAttribute, _ constant: CGFloat) -> [NSLayoutConstraint] {
        return Constraint.makeEq(firstItem, secondItem, attributes, constant, 1.0)
    }
    
    class func makeEq(firstItem: AnyObject, _ secondItem: AnyObject?, _ attributes: LayoutAttribute) -> [NSLayoutConstraint] {
        return Constraint.makeEq(firstItem, secondItem, attributes, 0.0)
    }
    
    // This part especially for dimensions
    
    class func makeEq(item: AnyObject, _ attributes: LayoutAttribute, _ constant: CGFloat, _ multiplier: CGFloat) -> [NSLayoutConstraint] {
        return Constraint.makeEq(item, nil, attributes, constant, multiplier)
    }
    
    class func makeEq(item: AnyObject, _ attributes: LayoutAttribute, _ constant: CGFloat) -> [NSLayoutConstraint] {
        return Constraint.makeEq(item, nil, attributes, constant, 1.0)
    }
}

extension NSLayoutConstraint {
    public func addToView(view: UIView) -> NSLayoutConstraint {
        view.addConstraint(self)
        return self
    }
}