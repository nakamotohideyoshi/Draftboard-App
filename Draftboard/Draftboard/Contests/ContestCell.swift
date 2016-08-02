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

class ContestCell: DraftboardTableViewCell {
    
    let nameLabel = UILabel()
    let prizesLabel = UILabel()
    let entryCountLabel = UILabel()
    let sportIcon = UIImageView()
    let actionButton = UIButton()
    let borderView = UIView()
    
    var showBottomBorder: Bool = true { didSet { updateBottomBorder() } }
    
    weak var actionButtonDelegate: LineupPlayerCellActionButtonDelegate?
    
    override func setup() {
        super.setup()
        
        // Subviews
        contentView.addSubview(nameLabel)
        contentView.addSubview(prizesLabel)
        contentView.addSubview(entryCountLabel)
        contentView.addSubview(sportIcon)
        contentView.addSubview(actionButton)
        contentView.addSubview(borderView)
        
        // Visual settings
        nameLabel.font = .openSans(size: 13)
        nameLabel.textColor = .whiteColor()
        
        prizesLabel.font = .openSans(weight: .Semibold, size: 10)
        prizesLabel.textColor = .whiteMediumOpacity()
        
        entryCountLabel.font = .openSans(weight: .Semibold, size: 10)
        entryCountLabel.textAlignment = .Right
        entryCountLabel.textColor = UIColor(0x25bd5e)
        
        sportIcon.image = UIImage(named: "icon-baseball")
        sportIcon.tintColor = UIColor(0x9c9faf)
        
        actionButton.setImage(UIImage(named: "icon-add"), forState: .Normal)
        actionButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
        
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
        let borderViewSize = CGSizeMake(boundsW - 30, 1)
        
        let (nameLabelW, nameLabelH) = (nameLabelSize.width, nameLabelSize.height)
        let (prizesLabelW, prizesLabelH) = (prizesLabelSize.width, prizesLabelSize.height)
        let (entryCountLabelW, entryCountLabelH) = (entryCountLabelSize.width, entryCountLabelSize.height)
        let (actionButtonW, actionButtonH) = (actionButtonSize.width, actionButtonSize.height)
        let (sportIconW, sportIconH) = (sportIconSize.width, sportIconSize.height)
        let (borderViewW, borderViewH) = (borderViewSize.width, borderViewSize.height)
        
        let nameLabelY = boundsH / 2 - (nameLabelH + prizesLabelH) / 2 - 1
        let prizesLabelY = nameLabelY + nameLabelH + 2
        let entryCountLabelX = boundsW - actionButtonW - entryCountLabelW
        let entryCountLabelY = boundsH / 2 - entryCountLabelH / 2
        let actionButtonX = boundsW - actionButtonW
        let sportIconY = boundsH / 2 - sportIconH / 2
        let borderViewY = boundsH - 1
        
        nameLabel.frame = CGRectMake(54, nameLabelY, nameLabelW, nameLabelH)
        prizesLabel.frame = CGRectMake(54, prizesLabelY, prizesLabelW, prizesLabelH)
        entryCountLabel.frame = CGRectMake(entryCountLabelX, entryCountLabelY, entryCountLabelW, entryCountLabelH)
        sportIcon.frame = CGRectMake(15, sportIconY, sportIconW, sportIconH)
        actionButton.frame = CGRectMake(actionButtonX, 0, actionButtonW, actionButtonH)
        borderView.frame = CGRectMake(15, borderViewY, borderViewW, borderViewH)
    }
    
    func configure(for contest: Contest?) {
        nameLabel.text = contest?.name ?? ""
        prizesLabel.text = "1st: $400 | 2nd: $300 | 3rd: $200"
        entryCountLabel.text = "X2"
    }
    
    func updateBottomBorder() {
        borderView.hidden = !showBottomBorder
    }
    
    func actionButtonTapped() {
        print("action button tapped!")
//        actionButtonDelegate?.actionButtonTappedForCell(self)
    }
    
}