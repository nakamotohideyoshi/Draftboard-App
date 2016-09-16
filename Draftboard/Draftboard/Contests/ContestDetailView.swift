//
//  ContestDetailView.swift
//  Draftboard
//
//  Created by Anson Schall on 9/5/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class ContestDetailView: DraftboardView {
    
    let tableView = ContestDetailTableView()
    let headerView = ContestDetailHeaderView()
    let panelView = ContestDetailPanelView()
    var enterButton: DraftboardTextButton { return panelView.enterButton }
    var entryCountLabel: UILabel { return panelView.entryCountLabel }
    var segmentedControl: DraftboardSegmentedControl { return panelView.segmentedControl }
    var countdownView: CountdownView { return headerView.countdownView }
    var prizeStatView: ModalStatView { return headerView.prizeStatView }
    var entrantsStatView: ModalStatView { return headerView.entrantsStatView }
    var feeStatView: ModalStatView { return headerView.feeStatView }
    
    override func setup() {
        super.setup()
        
        // Add subviews
        addSubview(tableView)
        tableView.addSubview(headerView)
        tableView.addSubview(panelView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let boundsSize = bounds.size
        let boundsW = boundsSize.width
        let boundsH = boundsSize.height
        
        // Within tableView:
        
        let headerViewSize = headerView.sizeThatFits(boundsSize)
        let headerViewW = headerViewSize.width
        let headerViewH = headerViewSize.height
        let headerViewX = CGFloat(0)
        let headerViewY = CGFloat(76)
        
        let panelViewSize = panelView.sizeThatFits(boundsSize)
        let panelViewW = panelViewSize.width
        let panelViewH = panelViewSize.height
        let panelViewX = CGFloat(0)
        let panelViewY = headerViewY + headerViewH
        
        // Within self:
        
        let tableViewX = CGFloat(0)
        let tableViewY = CGFloat(0)
        let tableViewW = boundsW
        let tableViewH = boundsH
        
        let tableViewWrapperMaskX = CGFloat(0)
        let tableViewWrapperMaskY = panelViewH + 76
        let tableViewWrapperMaskW = tableViewW
        let tableViewWrapperMaskH = tableViewH - tableViewWrapperMaskY
        
        let tableViewInsetTop = panelViewY + panelViewH
        
        headerView.frame = CGRectMake(headerViewX, headerViewY - tableViewInsetTop, headerViewW, headerViewH)
        panelView.frame = CGRectMake(panelViewX, panelViewY - tableViewInsetTop, panelViewW, panelViewH)
        tableView.frame = CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH)
        
        tableView.contentInset = UIEdgeInsetsMake(tableViewInsetTop, 0, 0, 0)
        tableView.wrapperMaskFrame = CGRectMake(tableViewWrapperMaskX, tableViewWrapperMaskY, tableViewWrapperMaskW, tableViewWrapperMaskH)
    }

}
