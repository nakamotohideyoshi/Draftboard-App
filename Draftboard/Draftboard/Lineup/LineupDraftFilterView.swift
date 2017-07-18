//
//  LineupDraftFilterView.swift
//  Draftboard
//
//  Created by devguru on 7/15/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

protocol LineupDraftFilterViewDelegate {
    func didTapGameSelectView()
    func didTapSortButton()
    func didTapSortView()
}

struct SortOption : OptionSetType {
    let rawValue: Int
    static let Salary = SortOption(rawValue: 0)
    static let FPoint = SortOption(rawValue: 1 << 0)
}

class LineupDraftFilterView: UIView {
    
    let gameSelectView = UIView()
    let gameLabel = DraftboardLabel()
    let iconDown = UIImageView()
    
    let sortView = UIView()
    let sortLabel = DraftboardLabel()
    let iconSortDown = UIImageView()
    
    let sortButton = DraftboardButton()
    
    var selectedGame: Game? { didSet { setGame() } }
    var selectedSortOption: SortOption? { didSet {setSortOption() } }
    var desc = true { didSet { sortOrderChanged() } }
    
    var delegate: LineupDraftFilterViewDelegate?
    var tapGestureRecognizer: UITapGestureRecognizer!
    var tapGestureRecognizer1: UITapGestureRecognizer!
    
    init() {
        super.init(frame: CGRectZero)
        setup()
    }
    
    override convenience init(frame: CGRect) {
        self.init()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    func setup() {
        addSubviews()
        addConstraints()
        otherSetup()
    }
    
    func addSubviews() {
        addSubview(gameSelectView)
        gameSelectView.addSubview(gameLabel)
        gameSelectView.addSubview(iconDown)
        addSubview(sortView)
        sortView.addSubview(sortLabel)
        sortView.addSubview(iconSortDown)
        addSubview(sortButton)
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            gameSelectView.leftRancor.constraintEqualToRancor(leftRancor, constant: 22.0),
            gameSelectView.centerYRancor.constraintEqualToRancor(centerYRancor),
            gameLabel.topRancor.constraintEqualToRancor(gameSelectView.topRancor),
            gameLabel.leftRancor.constraintEqualToRancor(gameSelectView.leftRancor),
            gameLabel.bottomRancor.constraintEqualToRancor(gameSelectView.bottomRancor),
            iconDown.leftRancor.constraintEqualToRancor(gameLabel.rightRancor, constant: 5.0),
            iconDown.centerYRancor.constraintEqualToRancor(gameLabel.centerYRancor),
            iconDown.widthRancor.constraintEqualToConstant(5),
            iconDown.heightRancor.constraintEqualToConstant(3),
            iconDown.rightRancor.constraintEqualToRancor(gameSelectView.rightRancor),
            
            sortView.rightRancor.constraintEqualToRancor(sortButton.leftRancor, constant: -16.0),
            sortView.centerYRancor.constraintEqualToRancor(centerYRancor),
            iconSortDown.leftRancor.constraintEqualToRancor(sortView.leftRancor),
            iconSortDown.centerYRancor.constraintEqualToRancor(sortLabel.centerYRancor),
            iconSortDown.widthRancor.constraintEqualToConstant(5),
            iconSortDown.heightRancor.constraintEqualToConstant(3),
            iconSortDown.rightRancor.constraintEqualToRancor(sortLabel.leftRancor, constant: -5.0),
            sortLabel.topRancor.constraintEqualToRancor(sortView.topRancor),
            sortLabel.rightRancor.constraintEqualToRancor(sortView.rightRancor),
            sortLabel.bottomRancor.constraintEqualToRancor(sortView.bottomRancor),
            sortLabel.widthRancor.constraintEqualToConstant(40),
            
            sortButton.rightRancor.constraintEqualToRancor(rightRancor, constant: -22.0),
            sortButton.centerYRancor.constraintEqualToRancor(centerYRancor),
            sortButton.widthRancor.constraintEqualToConstant(12),
            sortButton.heightRancor.constraintEqualToConstant(14),
        ]
        
        gameSelectView.translatesAutoresizingMaskIntoConstraints = false
        gameLabel.translatesAutoresizingMaskIntoConstraints = false
        iconDown.translatesAutoresizingMaskIntoConstraints = false
        sortView.translatesAutoresizingMaskIntoConstraints = false
        sortLabel.translatesAutoresizingMaskIntoConstraints = false
        iconSortDown.translatesAutoresizingMaskIntoConstraints = false
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func otherSetup() {
        backgroundColor = UIColor(0x444c57)
        
        gameLabel.font = .openSans(weight: .Semibold, size: 9)
        gameLabel.textColor = UIColor.whiteColor()
        gameLabel.letterSpacing = 0.5
        iconDown.image = UIImage(named:"icon-down")
        iconDown.tintColor = UIColor.whiteColor()
        
        sortLabel.font = .openSans(weight: .Semibold, size: 9)
        sortLabel.textColor = UIColor.whiteColor()
        sortLabel.letterSpacing = 0.5
        sortLabel.text = "Salary".uppercaseString
        iconSortDown.image = UIImage(named:"icon-arrow-down")
        iconSortDown.tintColor = UIColor.whiteColor()
        
        sortButton.iconImage = UIImage(named: "titlebar-icon-menu")
        sortButton.bgColor = .clearColor()
        sortButton.bgHighlightColor = .clearColor()
        sortButton.iconImageView.contentMode = .ScaleAspectFit
        sortButton.addTarget(self, action: #selector(didTapSortButton), forControlEvents: .TouchUpInside)
        
        tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: .didTapGameSelectView)
        gameSelectView.addGestureRecognizer(tapGestureRecognizer)
        
        tapGestureRecognizer1 = UITapGestureRecognizer()
        tapGestureRecognizer1.addTarget(self, action: .didTapSortView)
        sortView.addGestureRecognizer(tapGestureRecognizer1)
        
        selectedGame = nil
        selectedSortOption = .Salary
        
    }
    
    func setGame() {
        if selectedGame == nil {
            gameLabel.text = "All Games".uppercaseString
        } else {
            gameLabel.text = (selectedGame?.away.alias)! + " @ " + (selectedGame?.home.alias)!
        }
    }
    
    func setSortOption() {
        
        if selectedSortOption == .FPoint {
            self.sortLabel.text = "fppg".uppercaseString
        } else {
            self.sortLabel.text = "salary".uppercaseString
        }
    }
    
    func didTapGameSelectView(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.didTapGameSelectView()
    }
    
    func didTapSortView(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.didTapSortView()
    }
    
    func didTapSortButton() {
        delegate?.didTapSortButton()
    }
    
    func sortOrderChanged() {
        if desc == true {
            iconSortDown.image = UIImage(named:"icon-arrow-down")
        } else {
            iconSortDown.image = UIImage(named:"icon-arrow-up")
        }
    }
}

private extension Selector {
    static let didTapGameSelectView = #selector(LineupDraftFilterView.didTapGameSelectView(_:))
    static let didTapSortView = #selector(LineupDraftFilterView.didTapSortView(_:))
}
