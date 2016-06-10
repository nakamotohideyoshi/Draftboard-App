//
//  TableView.swift
//  Draftboard
//
//  Created by Anson Schall on 6/10/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

protocol CellAssociation {
    associatedtype Cell: UITableViewCell
    
    func registerCellClass()
    func registerClass(cellClass: AnyClass?, forCellReuseIdentifier identifier: String)
    
    func dequeueCellForIndexPath(indexPath: NSIndexPath) -> Cell
    func dequeueReusableCellWithIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> UITableViewCell
}

extension CellAssociation {
    func registerCellClass() {
        registerClass(Cell.self, forCellReuseIdentifier: String(Cell))
    }
    func dequeueCellForIndexPath(indexPath: NSIndexPath) -> Cell {
        return dequeueReusableCellWithIdentifier(String(Cell), forIndexPath: indexPath) as! Cell
    }
}
