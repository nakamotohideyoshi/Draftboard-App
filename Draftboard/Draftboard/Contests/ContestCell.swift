//
//  ContestCell.swift
//  Draftboard
//
//  Created by Anson Schall on 7/29/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

protocol ContestCellActionButtonDelegate: class {
    func actionButtonTappedForCell(cell: ContestCell)
}

class ContestCellState {
    var hasEntries: Bool = false
    var hasPendingEntries: Bool = false
    var canEnter: Bool = false
}

class ContestCell: DraftboardTableViewCell {
    
    let nameLabel = UILabel()
    let prizesLabel = UILabel()
    let entryCountLabel = UILabel()
    let sportIcon = UIImageView()
    let actionButton = UIButton()
    let loaderView = LoaderView()
    let borderView = UIView()
    
    var enableActionButton: Bool = false
    var showBottomBorder: Bool = true { didSet { updateBottomBorder() } }
    
    weak var actionButtonDelegate: ContestCellActionButtonDelegate?
    
    override func setup() {
        super.setup()
        
        // Subviews
        contentView.addSubview(nameLabel)
        contentView.addSubview(prizesLabel)
        contentView.addSubview(entryCountLabel)
        contentView.addSubview(sportIcon)
        contentView.addSubview(actionButton)
        contentView.addSubview(loaderView)
        contentView.addSubview(borderView)
        
        // Visual settings
        nameLabel.font = .openSans(size: 13)
        nameLabel.textColor = .whiteColor()
        
        prizesLabel.font = .openSans(weight: .Semibold, size: 10)
        prizesLabel.textColor = .whiteMediumOpacity()
        
        entryCountLabel.font = .openSans(weight: .Semibold, size: 10)
        entryCountLabel.textAlignment = .Right
        entryCountLabel.textColor = UIColor(0x25bd5e)
        
        sportIcon.tintColor = .whiteColor()
        
        actionButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
        
        loaderView.lineWidth = 1.5
        
        borderView.backgroundColor = .dividerOnDarkColor()
        
        // Behavioral settings
        actionButton.addTarget(self, action: #selector(actionButtonTapped), forControlEvents: .TouchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        let (boundsW, boundsH) = (bounds.width, bounds.height)
        
        let nameLabelSize = nameLabel.sizeThatFits(CGSizeZero)
        let prizesLabelSize = prizesLabel.sizeThatFits(CGSizeZero)
        let entryCountLabelSize = entryCountLabel.sizeThatFits(CGSizeZero)
        let actionButtonSize = CGSizeMake(52, boundsH)
        let sportIconSize = CGSizeMake(15, 15)
        let loaderViewSize = CGSizeMake(20, 20)
        let borderViewSize = CGSizeMake(boundsW - 30, 1)
        
        let (nameLabelW, nameLabelH) = (nameLabelSize.width, nameLabelSize.height)
        let (prizesLabelW, prizesLabelH) = (prizesLabelSize.width, prizesLabelSize.height)
        let (entryCountLabelW, entryCountLabelH) = (entryCountLabelSize.width, entryCountLabelSize.height)
        let (actionButtonW, actionButtonH) = (actionButtonSize.width, actionButtonSize.height)
        let (sportIconW, sportIconH) = (sportIconSize.width, sportIconSize.height)
        let (loaderViewW, loaderViewH) = (loaderViewSize.width, loaderViewSize.height)
        let (borderViewW, borderViewH) = (borderViewSize.width, borderViewSize.height)
        
        let nameLabelY = boundsH / 2 - (nameLabelH + prizesLabelH) / 2 - 1
        let prizesLabelY = nameLabelY + nameLabelH + 2
        let entryCountLabelX = boundsW - actionButtonW - entryCountLabelW
        let entryCountLabelY = boundsH / 2 - entryCountLabelH / 2
        let actionButtonX = boundsW - actionButtonW
        let sportIconY = boundsH / 2 - sportIconH / 2
        let loaderViewX = entryCountLabelX - loaderViewW
        let loaderViewY = boundsH / 2 - loaderViewH / 2
        let borderViewY = boundsH - 1
        
        nameLabel.frame = CGRectMake(54, nameLabelY, nameLabelW, nameLabelH)
        prizesLabel.frame = CGRectMake(54, prizesLabelY, prizesLabelW, prizesLabelH)
        entryCountLabel.frame = CGRectMake(entryCountLabelX, entryCountLabelY, entryCountLabelW, entryCountLabelH)
        sportIcon.frame = CGRectMake(15, sportIconY, sportIconW, sportIconH)
        actionButton.frame = CGRectMake(actionButtonX, 0, actionButtonW, actionButtonH)
        loaderView.frame = CGRectMake(loaderViewX, loaderViewY, loaderViewW, loaderViewH)
        borderView.frame = CGRectMake(15, borderViewY, borderViewW, borderViewH)
    }
    
    func configure(for contest: Contest, state: ContestCellState) {
        nameLabel.text = contest.name
        prizesLabel.text = contest.payoutDescription
        sportIcon.image = Sport.icons[contest.sportName]
        
        // Pending entries
        loaderView.alpha = state.hasPendingEntries ? 0.5 : 0
        actionButton.alpha = state.hasPendingEntries ? 0.5 : 1

        // Entries
        if state.hasEntries {
            let entries = (contest as! HasEntries).entries
            entryCountLabel.text = "   x\(entries.count)"
            sportIcon.alpha = 1
            if state.canEnter {
                actionButton.setImage(.actionButtonAddFilled, forState: .Normal)
            } else {
                actionButton.setImage(.actionButtonAddFilledGray, forState: .Normal)
            }
        }
        // No entries
        else {
            entryCountLabel.text = nil
            sportIcon.alpha = 0.3
            if state.canEnter {
                actionButton.setImage(.actionButtonAdd, forState: .Normal)
            } else {
                actionButton.setImage(.actionButtonAddGray, forState: .Normal)
            }
        }
    }
    
    func updateBottomBorder() {
        borderView.hidden = !showBottomBorder
    }
    
    func actionButtonTapped() {
        actionButtonDelegate?.actionButtonTappedForCell(self)
    }
    
}

private extension UIImage {
    static let actionButtonAdd = UIImage(named: "contest-action-add")
    static let actionButtonAddGray = UIImage(named: "contest-action-add-gray")
    static let actionButtonAddFilled = UIImage(named: "contest-action-add-filled")
    static let actionButtonAddFilledGray = UIImage(named: "contest-action-add-filled-gray")
}