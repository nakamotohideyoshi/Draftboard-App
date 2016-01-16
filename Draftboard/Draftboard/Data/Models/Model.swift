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
    
    internal func log(message: String, function: String = __FUNCTION__) {
        print("\(message) in \(self.dynamicType).\(function)")
    }
}
