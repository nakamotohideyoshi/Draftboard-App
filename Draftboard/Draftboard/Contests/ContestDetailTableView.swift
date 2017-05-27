//
//  ContestDetailTableView.swift
//  Draftboard
//
//  Created by Anson Schall on 9/14/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class ContestDetailTableView: DraftboardTableView {
    
    var wrapperMaskFrame: CGRect?
    
    override func setup() {
        super.setup()
        
        backgroundColor = .clearColor()

        tableFooterView = UIView()
        tableFooterView?.backgroundColor = .whiteColor()
        
        wrapperView?.maskView = UIView()
        wrapperView?.maskView?.backgroundColor = .whiteColor()
        
        registerClass(ContestDetailTableViewCell.self, forCellReuseIdentifier: String(ContestDetailTableViewCell))
        registerClass(ContestDetailTableViewHeaderCell.self, forCellReuseIdentifier: String(ContestDetailTableViewHeaderCell))
        registerClass(ContestDetailMyEntryCell.self, forCellReuseIdentifier: String(ContestDetailMyEntryCell))
        registerClass(ContestDetailGDescriptionCell.self, forCellReuseIdentifier: String(ContestDetailGDescriptionCell))
        registerClass(ContestDetailEntryCell.self, forCellReuseIdentifier: String(ContestDetailEntryCell))
        registerClass(ContestDetailPrizeCell.self, forCellReuseIdentifier: String(ContestDetailPrizeCell))
        registerClass(ContestDetailGameCell.self, forCellReuseIdentifier: String(ContestDetailGameCell))
        registerClass(ContestDetailScoringCell.self, forCellReuseIdentifier: String(ContestDetailScoringCell))
        registerClass(ContestDetailScoringHeaderCell.self, forCellReuseIdentifier: String(ContestDetailScoringHeaderCell))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let boundsW = bounds.size.width
        let boundsH = bounds.size.height
        let boundsY = bounds.origin.y
        
        let contentH = contentSize.height

        let tableFooterViewW = boundsW
        let tableFooterViewH = boundsH
        let tableFooterViewX = CGFloat(0)
        let tableFooterViewY = contentH
        
        tableFooterView?.frame = CGRectMake(tableFooterViewX, tableFooterViewY, tableFooterViewW, tableFooterViewH)

        if let frame = wrapperMaskFrame {
            wrapperView?.maskView?.frame = CGRectOffset(frame, 0, boundsY)
        } else {
            wrapperView?.maskView?.frame = bounds
        }
    }
    
}
