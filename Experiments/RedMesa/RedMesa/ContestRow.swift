//
//  ContestRow.swift
//  RedMesa
//
//  Created by Karl Weber on 9/9/15.
//  Copyright (c) 2015 Rally Interactive. All rights reserved.
//

import UIKit

class ContestRow: NSObject {
   
    var title: String
    
    var items: Array<String>
    
    init(text: String, items: Array<String>) {
        self.title = text
        self.items = items
    }
    
}
