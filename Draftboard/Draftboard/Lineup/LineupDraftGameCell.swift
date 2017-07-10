//
//  LineupDraftGameCell.swift
//  Draftboard
//
//  Created by devguru on 7/11/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class LineupDraftGameCell: UITableViewCell {

    let gameLabel = DraftboardLabel()
    let timeLabel = DraftboardLabel()
    let iconCheck = UIImageView()
    
    let borderView = UIView()
    
    var selectedGame: Bool = false { didSet { toggleIconCheck() } }
    
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
        addConstraints()
    }
    
    func addSubviews() {
        contentView.addSubview(gameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(iconCheck)
        contentView.addSubview(borderView)
    }
    
    func setupSubviews() {
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        
        gameLabel.font = .oswald(size: 16)
        gameLabel.textColor = UIColor.whiteColor()
        gameLabel.letterSpacing = 0.5
        gameLabel.text = "phi @ los".uppercaseString
        
        timeLabel.font = UIFont.openSans(weight: .Semibold, size: 10)
        timeLabel.textColor = UIColor(0xb0b2c1)
        timeLabel.letterSpacing = 0.5
        
        iconCheck.image = UIImage(named: "icon-check")
        iconCheck.contentMode = .ScaleAspectFit
        iconCheck.hidden = !selectedGame
        
        borderView.backgroundColor = UIColor(0x5c656f)
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            gameLabel.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 30),
            gameLabel.topRancor.constraintEqualToRancor(contentView.topRancor, constant: 15),
            timeLabel.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 30),
            timeLabel.topRancor.constraintEqualToRancor(gameLabel.bottomRancor, constant: 0),
            iconCheck.widthRancor.constraintEqualToConstant(12),
            iconCheck.heightRancor.constraintEqualToConstant(10),
            iconCheck.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            iconCheck.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -30),
            borderView.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 20),
            borderView.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -20),
            borderView.bottomRancor.constraintEqualToRancor(contentView.bottomRancor),
            borderView.heightRancor.constraintEqualToConstant(1),
        ]
        
        gameLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        iconCheck.translatesAutoresizingMaskIntoConstraints = false
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func setGame(game: Game?) {
        // No player
        guard let game = game else {
            gameLabel.text = "all games".uppercaseString
            timeLabel.text = nil
            return
        }
        
        gameLabel.text = game.away.alias + "@" + game.home.alias
        let df = NSDateFormatter()
        df.dateFormat = "h:mm a"
        timeLabel.text = df.stringFromDate(game.start)
    }
    
    func toggleIconCheck() {
        iconCheck.hidden = !selectedGame
    }
}
