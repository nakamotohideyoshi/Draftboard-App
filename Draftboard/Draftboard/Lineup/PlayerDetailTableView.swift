//
//  PlayerDetailTableView.swift
//  Draftboard
//
//  Created by Anson Schall on 9/20/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class PlayerDetailTableView: DraftboardTableView {
    
    var wrapperMaskFrame: CGRect?
    
    override func setup() {
        super.setup()
        
        backgroundColor = .clearColor()
        
        tableFooterView = UIView()
        tableFooterView?.backgroundColor = .whiteColor()
        
        wrapperView?.maskView = UIView()
        wrapperView?.maskView?.backgroundColor = .whiteColor()
        
        registerClass(PlayerDetailTableViewCell.self, forCellReuseIdentifier: String(PlayerDetailTableViewCell))
        registerClass(PlayerReportCell.self, forCellReuseIdentifier: String(PlayerReportCell))
        registerClass(MLBPitcherGameLogHeaderCell.self, forCellReuseIdentifier: String(MLBPitcherGameLogHeaderCell))
        registerClass(MLBPitcherGameLogCell.self, forCellReuseIdentifier: String(MLBPitcherGameLogCell))
        registerClass(MLBHitterGameLogHeaderCell.self, forCellReuseIdentifier: String(MLBHitterGameLogHeaderCell))
        registerClass(MLBHitterGameLogCell.self, forCellReuseIdentifier: String(MLBHitterGameLogCell))
        registerClass(NFLQBGameLogHeaderCell.self, forCellReuseIdentifier: String(NFLQBGameLogHeaderCell))
        registerClass(NFLQBGameLogCell.self, forCellReuseIdentifier: String(NFLQBGameLogCell))
        registerClass(NFLRBGameLogHeaderCell.self, forCellReuseIdentifier: String(NFLRBGameLogHeaderCell))
        registerClass(NFLRBGameLogCell.self, forCellReuseIdentifier: String(NFLRBGameLogCell))
        registerClass(NFLGameLogHeaderCell.self, forCellReuseIdentifier: String(NFLGameLogHeaderCell))
        registerClass(NFLGameLogCell.self, forCellReuseIdentifier: String(NFLGameLogCell))

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
