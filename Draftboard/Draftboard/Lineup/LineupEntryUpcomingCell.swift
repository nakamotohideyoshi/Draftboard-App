//
//  LineupEntryUpcomingCell.swift
//  Draftboard
//
//  Created by devguru on 8/8/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

protocol LineupEntryUpcomingCellActionButtonDelegate: class {
    func removeButtonTappedForCell(cell: LineupEntryUpcomingCell)
}

class LineupEntryUpcomingCell: UITableViewCell {
    
    let actionButton = UIButton()
    let nameLabel = UILabel()
    let feesLabel = UILabel()
    let borderView = UIView()
    
    weak var actionButtonDelegate: LineupEntryUpcomingCellActionButtonDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    override func layoutSubviews() {
        actionButton.frame = CGRectMake(15, (bounds.height - 15) / 2, 15, 15)
        nameLabel.frame = CGRectMake(50, 0, bounds.width - 80, bounds.height)
        feesLabel.frame = CGRectMake(bounds.width - 80, 0, 70, bounds.height)
        borderView.frame = CGRectMake(0, bounds.height - 1, bounds.width, 1)
    }
    
    func setup() {
        addSubviews()
        setupSubviews()
    }
    
    func addSubviews() {
        contentView.addSubview(actionButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(feesLabel)
        contentView.addSubview(borderView)
    }
    
    func setupSubviews() {
        backgroundColor = UIColor(0x37414d)
        
        actionButton.setImage(UIImage(named: "lineup-entry-action-remove"), forState: .Normal)
        
        nameLabel.font = .openSans(size: 11)
        nameLabel.textColor = .whiteColor()
        
        feesLabel.font = UIFont.oswald(size: 12)
        feesLabel.textColor = .whiteColor()
        feesLabel.textAlignment = .Right
        
        borderView.backgroundColor = UIColor(0x5f626d)
        
        actionButton.addTarget(self, action: #selector(actionButtonTapped), forControlEvents: .TouchUpInside)
    }
    
    func actionButtonTapped() {
        actionButtonDelegate?.removeButtonTappedForCell(self)
    }

}
