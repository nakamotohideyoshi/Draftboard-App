//
//  LineupPlayerCell.swift
//  Draftboard
//
//  Created by Anson Schall on 5/19/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class LineupPlayerCell: UITableViewCell {
    
    static let reuseIdentifier = "LineupPlayerCell"
    
    let positionLabel = UILabel()
    let avatarImageView = AvatarImageView()
    let nameLabel = UILabel()
    let teamLabel = UILabel()
    let salaryLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: LineupPlayerCell.reuseIdentifier)
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
        contentView.addSubview(teamLabel)
        contentView.addSubview(salaryLabel)
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
//            contentView.topRancor.constraintEqualToRancor(topRancor),
//            contentView.leftRancor.constraintEqualToRancor(leftRancor),
//            contentView.rightRancor.constraintEqualToRancor(rightRancor),
//            contentView.bottomRancor.constraintEqualToRancor(bottomRancor),
            
            positionLabel.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            positionLabel.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 10.0),
//            positionLabel.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -2.0),
//            positionLabel.bottomRancor.constraintEqualToRancor(contentView.bottomRancor, constant: -2.0),
            
            avatarImageView.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            avatarImageView.leftRancor.constraintEqualToRancor(positionLabel.rightRancor, constant: 10.0),
            avatarImageView.widthRancor.constraintEqualToConstant(40.0),
            avatarImageView.heightRancor.constraintEqualToConstant(40.0),
            
//            avatarImageView.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -2.0),
//            avatarImageView.bottomRancor.constraintEqualToRancor(contentView.bottomRancor, constant: -2.0),
            
            nameLabel.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            nameLabel.leftRancor.constraintEqualToRancor(avatarImageView.rightRancor, constant: 10.0),
//            nameLabel.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: 40.0),
//            nameLabel.heightRancor.constraintEqualToConstant(25.0),
            
            teamLabel.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            teamLabel.leftRancor.constraintEqualToRancor(nameLabel.rightRancor, constant: 10.0),

        ]
        
//        translatesAutoresizingMaskIntoConstraints = false
//        contentView.translatesAutoresizingMaskIntoConstraints = false
        positionLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        teamLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func setupSubviews() {
//        contentView.backgroundColor = .clearColor()
//        lineupView.backgroundColor = .whiteColor()
//        
//        shadowView.opaque = false
//        shadowView.layer.rasterizationScale = UIScreen.mainScreen().scale
//        shadowView.layer.shouldRasterize = true
//        
//        lineupView.layer.allowsEdgeAntialiasing = true
//        createView.layer.allowsEdgeAntialiasing = true
//        shadowView.layer.allowsEdgeAntialiasing = true
    }

    var player: Player? {
        didSet {
            avatarImageView.player = player
            nameLabel.text = player?.shortName
            player?.getTeam().then { team in
                self.teamLabel.text = team.alias
            }
//            salaryLabel.text = Format.currency.stringFromNumber(player?.salary ?? 0)
        }
    }
}

