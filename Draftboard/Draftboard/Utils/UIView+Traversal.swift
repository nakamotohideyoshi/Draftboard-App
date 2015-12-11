//
//  UIView+Traversal.swift
//  Draftboard
//
//  Created by Anson Schall on 12/10/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

extension UIView {
    // Breadth-first search for a subview of a specific type
    func descendantViewOfType<T: UIView>(type: T.Type) -> T? {
        for subview in subviews {
            if subview.isKindOfClass(T) {
                return subview as? T
            }
        }
        for subview in subviews {
            if let match = subview.descendantViewOfType(T) {
                return match
            }
        }
        return nil
    }
}
