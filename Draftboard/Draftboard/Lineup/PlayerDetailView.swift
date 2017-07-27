//
//  PlayerDetailView.swift
//  Draftboard
//
//  Created by Anson Schall on 9/20/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class PlayerDetailView: DraftboardView {
    
    let backgroundView = UIView()
    let tableView = PlayerDetailTableView()
    let headerView = PlayerDetailHeaderView()
    let panelView = PlayerDetailPanelView()
    var draftButton: DraftboardTextButton { return panelView.draftButton }
    var gameDetailView: PlayerGameDetailView { return panelView.gameDetailView }
    var segmentedControl: DraftboardSegmentedControl { return panelView.segmentedControl }
    var avatarView: UIImageView { return headerView.avatarView }
    var avatarHaloView: UIImageView { return headerView.avatarHaloView }
    var avatarLoaderView: LoaderView { return headerView.avatarLoaderView }
    var nextGameLabel: DraftboardTextLabel { return headerView.nextGameLabel }
    var teamNameLabel: DraftboardTextLabel { return headerView.teamNameLabel }
    var posStatView: ModalStatView { return headerView.posStatView }
    var salaryStatView: ModalStatView { return headerView.salaryStatView }
    var fppgStatView: ModalStatView { return headerView.fppgStatView }
    
    override func setup() {
        super.setup()
        
        // Add subviews
        addSubview(backgroundView)
        addSubview(tableView)
        tableView.addSubview(headerView)
        tableView.addSubview(panelView)
        
        backgroundView.backgroundColor = UIColor.whiteColor()
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
        
        let backgroundViewX = CGFloat(0)
        let backgroundViewY = panelViewY + 30
        let backgroundViewW = boundsW
        let backgroundViewH = boundsH - backgroundViewY
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
        backgroundView.frame = CGRectMake(backgroundViewX, backgroundViewY, backgroundViewW, backgroundViewH)
        
        tableView.contentInset = UIEdgeInsetsMake(tableViewInsetTop, 0, 0, 0)
        tableView.wrapperMaskFrame = CGRectMake(tableViewWrapperMaskX, tableViewWrapperMaskY, tableViewWrapperMaskW, tableViewWrapperMaskH)
    }
    
}
