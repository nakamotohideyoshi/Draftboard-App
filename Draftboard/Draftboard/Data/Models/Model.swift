//
//  File.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import Foundation

class Model {
    var id: Int = 0
    
    internal func log(message: String, function: String = #function) {
        print("\(message) in \(self.dynamicType).\(function)")
    }
}

extension CustomStringConvertible {
    var description: String {
        let properties = Mirror(reflecting: self).children.flatMap { (label, value) -> String? in
            return (label == nil) ? nil : "\(label!): \(value)"
        }.joinWithSeparator(", ")

        return "{\(self.dynamicType) \(properties)}"
    }
}