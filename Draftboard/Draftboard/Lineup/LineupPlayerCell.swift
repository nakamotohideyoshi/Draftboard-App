//
//  LineupPlayerCell.swift
//  Draftboard
//
//  Created by Anson Schall on 5/19/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class LineupPlayerCell: UITableViewCell {
    
    private static let teamFont = UIFont.openSans(size: 10.0)
    private static let teamFontBold = UIFont.openSans(weight: .Semibold, size: 10.0)
    
    let positionLabel = UILabel()
    let avatarImageView = AvatarImageView()
    let nameLabel = UILabel()
    let nameTeamSeparatorLabel = UILabel()
    let homeLabel = UILabel()
    let vsLabel = UILabel()
    let awayLabel = UILabel()
    let fppgLabel = UILabel()
    let salaryLabel = UILabel()
    let borderView = UIView()
    
    var showAllInfo: Bool = false
    
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
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameTeamSeparatorLabel)
        contentView.addSubview(homeLabel)
        contentView.addSubview(vsLabel)
        contentView.addSubview(awayLabel)
        contentView.addSubview(fppgLabel)
        contentView.addSubview(salaryLabel)
        contentView.addSubview(borderView)
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            positionLabel.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            positionLabel.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 18.0),
            positionLabel.widthRancor.constraintEqualToConstant(18.0),
            
            avatarImageView.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            avatarImageView.leftRancor.constraintEqualToRancor(positionLabel.rightRancor, constant: 7.0),
            avatarImageView.widthRancor.constraintEqualToConstant(38.0),
            avatarImageView.heightRancor.constraintEqualToConstant(38.0),
            
            nameLabel.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            nameLabel.leftRancor.constraintEqualToRancor(avatarImageView.rightRancor, constant: 12.0),
            
            nameTeamSeparatorLabel.centerYRancor.constraintEqualToRancor(nameLabel.centerYRancor),
            nameTeamSeparatorLabel.leftRancor.constraintEqualToRancor(nameLabel.rightRancor, constant: 2.0),
            
            homeLabel.baseLineRancor.constraintEqualToRancor(nameLabel.baseLineRancor),
            homeLabel.leftRancor.constraintEqualToRancor(nameTeamSeparatorLabel.rightRancor, constant: 2.0),
            
            vsLabel.centerYRancor.constraintEqualToRancor(homeLabel.centerYRancor),
            vsLabel.leftRancor.constraintEqualToRancor(homeLabel.rightRancor),

            awayLabel.centerYRancor.constraintEqualToRancor(vsLabel.centerYRancor),
            awayLabel.leftRancor.constraintEqualToRancor(vsLabel.rightRancor),
            
            salaryLabel.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            salaryLabel.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -18.0),
            
            borderView.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 10.0),
            borderView.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -10.0),
            borderView.bottomRancor.constraintEqualToRancor(contentView.bottomRancor),
            borderView.heightRancor.constraintEqualToConstant(1.0)
        ]
        
        positionLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTeamSeparatorLabel.translatesAutoresizingMaskIntoConstraints = false
        homeLabel.translatesAutoresizingMaskIntoConstraints = false
        vsLabel.translatesAutoresizingMaskIntoConstraints = false
        awayLabel.translatesAutoresizingMaskIntoConstraints = false
        salaryLabel.translatesAutoresizingMaskIntoConstraints = false
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func setupSubviews() {
        positionLabel.font = .openSans(weight: .Semibold, size: 9.0)
        positionLabel.textColor = UIColor(0x9c9faf)

        nameLabel.font = .openSans(size: 13.0)
        nameLabel.textColor = UIColor(0x46495e)

        nameTeamSeparatorLabel.font = .openSans(size: 13.0)
        nameTeamSeparatorLabel.textColor = UIColor(0x9c9faf)

        homeLabel.font = LineupPlayerCell.teamFont
        homeLabel.textColor = UIColor(0x9c9faf)
        
        vsLabel.font = LineupPlayerCell.teamFont
        vsLabel.textColor = UIColor(0x9c9faf)
        
        awayLabel.font = LineupPlayerCell.teamFont
        awayLabel.textColor = UIColor(0x9c9faf)
        
        salaryLabel.font = .oswald(size: 13.0)
        salaryLabel.textColor = UIColor(0x46495e)
        
        borderView.backgroundColor = UIColor(0xebedf2)
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
            homeLabel.text = nil
            awayLabel.text = nil
            vsLabel.text = nil
            nameTeamSeparatorLabel.text = nil
            return
        }
        
        // Everything but team labels
        positionLabel.text = (player as? HasPosition)?.position
        avatarImageView.player = player
        nameLabel.text = player.shortName
        nameLabel.textColor = UIColor(0x46495e)
        fppgLabel.text = "\(player.fppg)"
        salaryLabel.text = Format.currency.stringFromNumber(player.salary)
        nameTeamSeparatorLabel.text = "-"
        
        // Game info if available
        if showAllInfo, let player = player as? HasGame {
            homeLabel.text = player.game.home.alias
            awayLabel.text = player.game.away.alias
            homeLabel.font = (player.game.home === player.team) ? LineupPlayerCell.teamFontBold : LineupPlayerCell.teamFont
            awayLabel.font = (player.game.away === player.team) ? LineupPlayerCell.teamFontBold : LineupPlayerCell.teamFont
            homeLabel.textColor = (player.game.home === player.team) ? UIColor(0x46495e) : UIColor(0x9c9faf)
            awayLabel.textColor = (player.game.away === player.team) ? UIColor(0x46495e) : UIColor(0x9c9faf)
            vsLabel.text = " vs "
        }
        // Just the team alias
        else {
            homeLabel.text = player.teamAlias
            homeLabel.font = LineupPlayerCell.teamFont
            homeLabel.textColor = UIColor(0x9c9faf)
            awayLabel.text = nil
            vsLabel.text = nil
        }

    }
}

