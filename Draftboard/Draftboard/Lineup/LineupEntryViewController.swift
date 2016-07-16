//
//  LineupEntryViewController.swift
//  Draftboard
//
//  Created by Anson Schall on 7/1/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class LineupEntryViewController: DraftboardViewController {
    
    var lineupEntryView: LineupEntryView { return view as! LineupEntryView }
    var tableView: UITableView { return lineupEntryView.tableView }
    var flipButton: UIButton { return lineupEntryView.flipButton }
    var sportIcon: UIImageView { return lineupEntryView.sportIcon }
    var nameLabel: UILabel { return lineupEntryView.nameLabel }

    var lineup: LineupWithStart? { didSet { viewDidLoad() } }
    var entries: [LineupEntry] = [] { didSet { tableView.reloadData() } }
    
    var flipAction: (() -> Void) = {}

    override func loadView() {
        self.view = LineupEntryView()
    }
    
    override func viewDidLoad() {
        // FIXME: Don't rely on lineup being non-nil
        if lineup == nil {
            let draftGroup = DraftGroup(id: 1, sportName: "nba", start: NSDate(), numGames: 0)
            lineup = LineupWithStart(draftGroup: draftGroup)
        }
        
        // Sport icon
        sportIcon.image = UIImage(named: "icon-baseball")
        
        // Lineup name
        nameLabel.text = lineup!.name
        
        // Edit button
        
        // Flip button
        
        // Players
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 40
//        tableView.rowHeight = 
        
        // Countdown
        lineupEntryView.footerView.countdown.countdownView.date = lineup!.start
        
        lineup?.getEntries().then { entries -> Void in
            self.entries = entries
            self.tableView.reloadData()
            let totalBuyin = entries.reduce(0) { $0 + $1.contest.buyin }
            let feesText = Format.currency.stringFromNumber(totalBuyin)!
            let text = "\(feesText) / \(entries.count)"
            self.lineupEntryView.footerView.feesEntries.valueLabel.text = text
        }
        
        flipButton.addTarget(self, action: #selector(flipButtonTapped), forControlEvents: .TouchUpInside)
    }
    
    func flipButtonTapped() {
        flipAction()
    }

}

private typealias TableViewDelegate = LineupEntryViewController
extension TableViewDelegate: UITableViewDataSource, UITableViewDelegate {
    
    // UITableViewDataSource
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = LineupEntryCell()
        
        let entry = entries[indexPath.row]
        cell.nameLabel.text = entry.contest.name
        cell.feesLabel.text = Format.currency.stringFromNumber(entry.contest.buyin)!
//        let action = {
//            entry.unregister()
//        }
        
        return cell
    }
    
    // UITableViewDelegate
    
    func tableView(_: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

class LineupEntryCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let feesLabel = UILabel()
    let borderView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    override func layoutSubviews() {
        nameLabel.frame = CGRectMake(18, 0, bounds.width - 80, bounds.height)
        feesLabel.frame = CGRectMake(bounds.width - 80, 0, 62, bounds.height)
        borderView.frame = CGRectMake(0, bounds.height - 1, bounds.width, 1)
    }

    func setup() {
        addSubviews()
        setupSubviews()
    }
    
    func addSubviews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(feesLabel)
        contentView.addSubview(borderView)
    }
    
    func setupSubviews() {
        backgroundColor = .clearColor()
        
        nameLabel.font = .openSans(size: 11)
        nameLabel.textColor = .whiteColor()
        
        feesLabel.font = UIFont.oswald(size: 12)
        feesLabel.textColor = .whiteColor()
        feesLabel.textAlignment = .Right

        borderView.backgroundColor = UIColor(0x5f626d)
    }

}


