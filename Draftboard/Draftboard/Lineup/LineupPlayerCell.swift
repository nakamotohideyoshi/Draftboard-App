//
//  LineupPlayerCell.swift
//  Draftboard
//
//  Created by Anson Schall on 5/19/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

protocol LineupPlayerCellActionButtonDelegate: class {
    func actionButtonTappedForCell(cell: LineupPlayerCell)
}

class LineupPlayerCell: UITableViewCell {
    
    enum ActionButtonType {
        case Add
        case Remove
    }
    
    let positionLabel = UILabel()
    let avatarImageView = AvatarImageView()
    let timeRemainingView = TimeRemainingView()
    let nameLabel = UILabel()
    let nameTeamSeparatorLabel = UILabel()
    let awayLabel = UILabel()
    let vsLabel = UILabel()
    let homeLabel = UILabel()
    let timeLabel = UILabel()
    let fppgLabel = UILabel()
    let salaryLabel = UILabel()
    let actionButton = UIButton()
    let borderView = UIView()
    
    let actionAddImage = UIImage(named: "icon-add")
    let actionRemoveImage = UIImage(named: "icon-remove")
    
    var showAllInfo: Bool = false
    var showAddButton: Bool = false { didSet { didSetShowAddButton() } }
    var showRemoveButton: Bool = false { didSet { didSetShowRemoveButton() } }
    var showBottomBorder: Bool = true { didSet { updateBottomBorder() } }
    var withinBudget: Bool = true { didSet { updateSalaryColor() } }
    
    weak var actionButtonDelegate: LineupPlayerCellActionButtonDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    func setup() {
        addSubviews()
        setupSubviews()
    }
    
    func addSubviews() {
        contentView.addSubview(positionLabel)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(timeRemainingView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameTeamSeparatorLabel)
        contentView.addSubview(awayLabel)
        contentView.addSubview(vsLabel)
        contentView.addSubview(homeLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(fppgLabel)

        contentView.addSubview(salaryLabel)
        contentView.addSubview(actionButton)
        contentView.addSubview(borderView)
    }
    
    func setupSubviews() {
        positionLabel.font = .openSans(weight: .Semibold, size: 9.0)
        positionLabel.textColor = UIColor(0x9c9faf)

        nameLabel.font = .openSans(size: 13.0)
        nameLabel.textColor = UIColor(0x46495e)

        nameTeamSeparatorLabel.font = .openSans(size: 13.0)
        nameTeamSeparatorLabel.textColor = UIColor(0x9c9faf)
        nameTeamSeparatorLabel.hidden = true
        
        awayLabel.textColor = UIColor(0x9c9faf)
        
        vsLabel.font = .openSans(size: 10.0)
        vsLabel.textColor = UIColor(0x9c9faf)
        
        homeLabel.textColor = UIColor(0x9c9faf)
        
        timeLabel.font = .openSans(weight: .Semibold, size: 10.0)
        timeLabel.textColor = UIColor(0x9c9faf)

        fppgLabel.font = .openSans(weight: .Semibold, size: 10.0)
        fppgLabel.textColor = UIColor(0x9c9faf)

        salaryLabel.font = .oswald(size: 13.0)
        salaryLabel.textColor = UIColor(0x46495e)
        
        actionButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
        
        borderView.backgroundColor = UIColor(0xebedf2)
        
        actionButton.addTarget(self, action: #selector(actionButtonTapped), forControlEvents: .TouchUpInside)
    }
    
    override func layoutSubviews() {
        let nameLabelSize = nameLabel.sizeThatFits(CGSizeZero)
        let nameTeamSeparatorLabelSize = nameTeamSeparatorLabel.sizeThatFits(CGSizeZero)
        let awayLabelSize = awayLabel.sizeThatFits(CGSizeZero)
        let vsLabelSize = vsLabel.sizeThatFits(CGSizeZero)
        let homeLabelSize = homeLabel.sizeThatFits(CGSizeZero)
        let timeLabelSize = timeLabel.sizeThatFits(CGSizeZero)
        let fppgLabelSize = fppgLabel.sizeThatFits(CGSizeZero)
        let salaryLabelSize = salaryLabel.sizeThatFits(CGSizeZero)
        let actionButtonSize = CGSizeMake(52, bounds.height)
        
        let infoHeight = nameLabelSize.height + (showAllInfo ? awayLabelSize.height + 2 : 0)
        let nameLabelOriginY = fitToPixel(bounds.height / 2 - infoHeight / 2)
        let fppgLabelOriginY = nameLabelOriginY + nameLabelSize.height + 2
        let awayLabelOriginY = nameLabelOriginY + nameLabelSize.height + 2
        let salaryLabelOriginY = fitToPixel(bounds.height / 2 - infoHeight / 2)
        
        let actionButtonOriginX = bounds.width - ((showAddButton || showRemoveButton) ? actionButtonSize.width : 0)
        let salaryLabelOriginX = bounds.width - salaryLabelSize.width - ((showAddButton || showRemoveButton) ? actionButtonSize.width : 18)
        let fppgLabelOriginX = bounds.width - fppgLabelSize.width - ((showAddButton || showRemoveButton) ? actionButtonSize.width : 18)
        
        var x: CGFloat = 18
        positionLabel.frame = CGRectMake(x, 0, 18, bounds.height)
        x += 18 + 7
        avatarImageView.frame = CGRectMake(x, bounds.height / 2 - 38 / 2, 38, 38)
        timeRemainingView.frame = avatarImageView.frame
        x += 38 + 12
        nameLabel.frame = CGRectMake(x, nameLabelOriginY, nameLabelSize.width, nameLabelSize.height)
        x += nameLabelSize.width + 2
        nameTeamSeparatorLabel.frame = CGRectMake(x, nameLabelOriginY, nameTeamSeparatorLabelSize.width, nameTeamSeparatorLabelSize.height)
        x += nameTeamSeparatorLabelSize.width + 2
        fppgLabel.frame = CGRectMake(fppgLabelOriginX, fppgLabelOriginY, fppgLabelSize.width, fppgLabelSize.height)
        
        var x1 = nameLabel.frame.origin.x
        awayLabel.frame = CGRectMake(x1, awayLabelOriginY, awayLabelSize.width, awayLabelSize.height)
        x1 += awayLabelSize.width
        vsLabel.frame = CGRectMake(x1, awayLabelOriginY, vsLabelSize.width, vsLabelSize.height)
        x1 += vsLabelSize.width
        homeLabel.frame = CGRectMake(x1, awayLabelOriginY, homeLabelSize.width, homeLabelSize.height)
        x1 += homeLabelSize.width + 2
        timeLabel.frame = CGRectMake(x1, awayLabelOriginY, timeLabelSize.width, timeLabelSize.height)
        
        salaryLabel.frame = CGRectMake(salaryLabelOriginX, salaryLabelOriginY, salaryLabelSize.width, salaryLabelSize.height)
        actionButton.frame = CGRectMake(actionButtonOriginX, 0, actionButtonSize.width, actionButtonSize.height)
        borderView.frame = CGRectMake(10, bounds.height - 1, bounds.width - 20, 1)
    }
    
    func setLineupSlot(slot: LineupSlot?) {
        guard let slot = slot else { return }
        
        setPlayer(slot.player)
        if slot.player == nil {
            nameLabel.text = "Select \(slot.description)"
            nameLabel.textColor = UIColor(0x9c9faf)
        }
        positionLabel.text = slot.name
    }
    
    func setPlayer(player: Player?) {
        // No player
        guard let player = player else {
            avatarImageView.player = nil
            fppgLabel.text = nil
            salaryLabel.text = nil
            awayLabel.text = nil
            homeLabel.text = nil
            vsLabel.text = nil
            nameTeamSeparatorLabel.text = nil
            timeLabel.text = nil
            return
        }
        
        // Everything but team labels
        positionLabel.text = (player as? HasPosition)?.position
        avatarImageView.player = player
        nameLabel.text = player.name
        nameLabel.textColor = UIColor(0x46495e)
        fppgLabel.text = String(format: "%.1f FPPG", player.fppg)
        salaryLabel.text = Format.currency.stringFromNumber(player.salary)
        nameTeamSeparatorLabel.text = "-"
        
        // Game info if available
        if showAllInfo, let p = player as? HasGame {
            awayLabel.text = p.game.away.alias
            homeLabel.text = p.game.home.alias
            awayLabel.font = (p.game.away === p.team) ? .openSans(weight: .Semibold, size: 10.0) : .openSans(size: 10.0)
            homeLabel.font = (p.game.home === p.team) ? .openSans(weight: .Semibold, size: 10.0) : .openSans(size: 10.0)
            awayLabel.textColor = (p.game.away === p.team) ? UIColor(0x46495e) : UIColor(0x9c9faf)
            homeLabel.textColor = (p.game.home === p.team) ? UIColor(0x46495e) : UIColor(0x9c9faf)
            vsLabel.text = " vs "
            let df = NSDateFormatter()
            df.dateFormat = "h:mm a"
            timeLabel.text = df.stringFromDate(p.game.start)
        }
        // Just the team alias
        else {
            awayLabel.text = player.teamAlias
            awayLabel.font = .openSans(size: 10.0)
            awayLabel.textColor = UIColor(0x9c9faf)
            awayLabel.text = nil
            homeLabel.text = nil
            vsLabel.text = nil
            timeLabel.text = nil
            fppgLabel.text = nil
        }

    }
    
    func didSetShowAddButton() {
        if showAddButton { showRemoveButton = false }
        actionButton.setImage(actionAddImage, forState: .Normal)
        actionButton.hidden = !(showAddButton || showRemoveButton)
    }
    
    func didSetShowRemoveButton() {
        if showRemoveButton { showAddButton = false }
        actionButton.setImage(actionRemoveImage, forState: .Normal)
        actionButton.hidden = !(showAddButton || showRemoveButton)
    }
    
    func updateBottomBorder() {
        borderView.hidden = !showBottomBorder
    }
    
    func updateSalaryColor() {
        salaryLabel.textColor = withinBudget ? UIColor(0x46495e) : UIColor(0xe42e2f)
    }
    
    func actionButtonTapped() {
        actionButtonDelegate?.actionButtonTappedForCell(self)
    }

}

func fitToPixel(value: CGFloat) -> CGFloat {
    let screen = UIScreen.mainScreen()
    return ceil(screen.scale * value) / screen.scale
}
