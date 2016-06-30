//
//  LineupPlayerCell.swift
//  Draftboard
//
//  Created by Anson Schall on 5/19/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

protocol LineupPlayerCellActionButtonDelegate {
    func actionButtonTappedForCell(cell: LineupPlayerCell)
}

class LineupPlayerCell: UITableViewCell {
    
    enum ActionButtonType {
        case Add
        case Remove
    }
    
    let infoView = UIView()
    let positionLabel = UILabel()
    let avatarImageView = AvatarImageView()
    let nameLabel = UILabel()
    let nameTeamSeparatorLabel = UILabel()
    let awayLabel = UILabel()
    let vsLabel = UILabel()
    let homeLabel = UILabel()
    let fppgLabel = UILabel()
    let salaryLabel = UILabel()
    let actionButton = UIButton()
    let borderView = UIView()
    
    var showAllInfo: Bool = false
    var showAddButton: Bool = false { didSet { if showAddButton { showRemoveButton = false }; updateActionButton() } }
    var showRemoveButton: Bool = false { didSet { if showRemoveButton { showAddButton = false }; updateActionButton() } }
    var showBottomBorder: Bool = true { didSet { updateBottomBorder() } }
    var withinBudget: Bool = true { didSet { updateSalaryColor() } }
    
    var actionButtonRightConstraint: NSLayoutConstraint?
    var actionButtonDelegate: LineupPlayerCellActionButtonDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    func setup() {
        addSubviews()
        addConstraints()
        setupSubviews()
    }
    
    func addSubviews() {
        contentView.addSubview(positionLabel)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(infoView)
        infoView.addSubview(nameLabel)
        infoView.addSubview(nameTeamSeparatorLabel)
        infoView.addSubview(awayLabel)
        infoView.addSubview(vsLabel)
        infoView.addSubview(homeLabel)
        infoView.addSubview(fppgLabel)
        contentView.addSubview(salaryLabel)
        contentView.addSubview(actionButton)
        contentView.addSubview(borderView)
    }
    
    func addConstraints() {
        actionButtonRightConstraint = actionButton.rightRancor.constraintEqualToRancor(contentView.rightRancor)

        let viewConstraints: [NSLayoutConstraint] = [
            positionLabel.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            positionLabel.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 18.0),
            positionLabel.widthRancor.constraintEqualToConstant(18.0),
            
            avatarImageView.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            avatarImageView.leftRancor.constraintEqualToRancor(positionLabel.rightRancor, constant: 7.0),
            avatarImageView.widthRancor.constraintEqualToConstant(38.0),
            avatarImageView.heightRancor.constraintEqualToConstant(38.0),
            
            infoView.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            infoView.leftRancor.constraintEqualToRancor(avatarImageView.rightRancor, constant: 12.0),
            infoView.rightRancor.constraintEqualToRancor(salaryLabel.leftRancor, constant: -6.0),
            
            nameLabel.topRancor.constraintEqualToRancor(infoView.topRancor),
            nameLabel.leftRancor.constraintEqualToRancor(infoView.leftRancor),
            
            nameTeamSeparatorLabel.centerYRancor.constraintEqualToRancor(nameLabel.centerYRancor),
            nameTeamSeparatorLabel.leftRancor.constraintEqualToRancor(nameLabel.rightRancor, constant: 2.0),
            
            awayLabel.baseLineRancor.constraintEqualToRancor(nameLabel.baseLineRancor),
            awayLabel.leftRancor.constraintEqualToRancor(nameTeamSeparatorLabel.rightRancor, constant: 2.0),
            
            vsLabel.centerYRancor.constraintEqualToRancor(awayLabel.centerYRancor),
            vsLabel.leftRancor.constraintEqualToRancor(awayLabel.rightRancor),

            homeLabel.centerYRancor.constraintEqualToRancor(vsLabel.centerYRancor),
            homeLabel.leftRancor.constraintEqualToRancor(vsLabel.rightRancor),
            
            fppgLabel.topRancor.constraintEqualToRancor(nameLabel.bottomRancor),
            fppgLabel.leftRancor.constraintEqualToRancor(nameLabel.leftRancor),
            fppgLabel.bottomRancor.constraintEqualToRancor(infoView.bottomRancor),
            
            actionButton.heightRancor.constraintEqualToRancor(contentView.heightRancor),
            actionButton.widthRancor.constraintEqualToConstant(52.0),
            actionButton.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            actionButtonRightConstraint!,
            
            salaryLabel.centerYRancor.constraintEqualToRancor(actionButton.centerYRancor),
            salaryLabel.rightRancor.constraintEqualToRancor(actionButton.leftRancor),
            
            borderView.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 10.0),
            borderView.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -10.0),
            borderView.bottomRancor.constraintEqualToRancor(contentView.bottomRancor),
            borderView.heightRancor.constraintEqualToConstant(1.0)
        ]

        
        infoView.translatesAutoresizingMaskIntoConstraints = false
        positionLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTeamSeparatorLabel.translatesAutoresizingMaskIntoConstraints = false
        awayLabel.translatesAutoresizingMaskIntoConstraints = false
        vsLabel.translatesAutoresizingMaskIntoConstraints = false
        homeLabel.translatesAutoresizingMaskIntoConstraints = false
        fppgLabel.translatesAutoresizingMaskIntoConstraints = false
        salaryLabel.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func setupSubviews() {
        positionLabel.font = .openSans(weight: .Semibold, size: 9.0)
        positionLabel.textColor = UIColor(0x9c9faf)

        infoView.clipsToBounds = true
        
        nameLabel.font = .openSans(size: 13.0)
        nameLabel.textColor = UIColor(0x46495e)

        nameTeamSeparatorLabel.font = .openSans(size: 13.0)
        nameTeamSeparatorLabel.textColor = UIColor(0x9c9faf)

        awayLabel.textColor = UIColor(0x9c9faf)
        
        vsLabel.font = .openSans(size: 10.0)
        vsLabel.textColor = UIColor(0x9c9faf)
        
        homeLabel.textColor = UIColor(0x9c9faf)

        fppgLabel.font = .openSans(weight: .Semibold, size: 10.0)
        fppgLabel.textColor = UIColor(0x9c9faf)

        salaryLabel.font = .oswald(size: 13.0)
        salaryLabel.textColor = UIColor(0x46495e)
        
        actionButton.setImage(UIImage(named: "icon-add"), forState: .Normal)
        actionButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
        
        borderView.backgroundColor = UIColor(0xebedf2)
        
        actionButton.addTarget(self, action: #selector(actionButtonTapped), forControlEvents: .TouchUpInside)
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
            return
        }
        
        // Everything but team labels
        positionLabel.text = (player as? HasPosition)?.position
        avatarImageView.player = player
        nameLabel.text = player.shortName
        nameLabel.textColor = UIColor(0x46495e)
        fppgLabel.text = showAllInfo ? String(format: "%.1f FPPG", player.fppg) : nil
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
        }
        // Just the team alias
        else {
            awayLabel.text = player.teamAlias
            awayLabel.font = .openSans(size: 10.0)
            awayLabel.textColor = UIColor(0x9c9faf)
            homeLabel.text = nil
            vsLabel.text = nil
        }

    }
    
    func updateActionButton() {
        if showAddButton || showRemoveButton {
            let imageName = showAddButton ? "icon-add" : "icon-remove"
            actionButton.setImage(UIImage(named: imageName), forState: .Normal)
            actionButtonRightConstraint?.constant = 0
            actionButton.hidden = false
        } else {
            actionButtonRightConstraint?.constant = actionButton.frame.width - 16.0
            actionButton.hidden = true
        }
        layoutIfNeeded()
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

