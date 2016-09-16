//
//  ContestDetailViewController.swift
//  Draftboard
//
//  Created by Anson Schall on 9/5/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class ContestDetailViewController: DraftboardViewController {
    
    override var overlapsTabBar: Bool { return true }
    
    var contestDetailView: ContestDetailView { return view as! ContestDetailView }
    var tableView: ContestDetailTableView { return contestDetailView.tableView }
    var headerView: ContestDetailHeaderView { return contestDetailView.headerView }
    var panelView: ContestDetailPanelView { return contestDetailView.panelView }
    var countdownView: CountdownView { return contestDetailView.countdownView }
    var prizeStatView: ModalStatView { return contestDetailView.prizeStatView }
    var entrantsStatView: ModalStatView { return contestDetailView.entrantsStatView }
    var feeStatView: ModalStatView { return contestDetailView.feeStatView }
    var enterButton: DraftboardTextButton { return contestDetailView.enterButton }
    var entryCountLabel: UILabel { return contestDetailView.entryCountLabel }
    var segmentedControl: DraftboardSegmentedControl { return contestDetailView.segmentedControl }
    
    var contest: Contest?
    
    override func loadView() {
        view = ContestDetailView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        segmentedControl.indexChangedHandler = { [weak self] (_: Int) in self?.filter() }
        
        countdownView.date = contest?.start ?? NSDate()
        
        prizeStatView.valueLabel.text = Format.currency.stringFromNumber(contest?.prizePool ?? 0)
        entrantsStatView.valueLabel.text = "\(contest?.currentEntries ?? 0)"
        feeStatView.valueLabel.text = Format.currency.stringFromNumber(contest?.buyin ?? 0)
        
        enterButton.label.text = "Enter Contest".uppercaseString

        entryCountLabel.text = "? of ? Max Entries"

        segmentedControl.choices = ["Payout", "Entries", "Scoring", "Games"]
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.contentOffset = CGPointMake(0, -tableView.contentInset.top)
    }
    
    func filter() {
        let contentOffsetY = tableView.contentOffset.y
        tableView.reloadData()
        tableView.contentOffset.y = contentOffsetY
        tableView.flashScrollIndicators()
        let last = tableView.indexPathsForVisibleRows!.last!
        tableView.scrollToRowAtIndexPath(last, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }
    
    // Titlebar
    
    override func titlebarTitle() -> String? {
        return contest?.name.uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType? {
        return .Back
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if buttonType == .Back {
            navController?.popViewController()
        }
    }

}

// MARK: -

private typealias TableViewDelegate = ContestDetailViewController
extension TableViewDelegate: UITableViewDataSource, UITableViewDelegate {
    
    // UITableViewDataSource
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 + segmentedControl.currentIndex * 5
    }
    
    func tableView(_: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(ContestDetailTableViewCell), forIndexPath: indexPath)
        let subsectionName = segmentedControl.choices[segmentedControl.currentIndex]
        cell.textLabel?.text = "\(subsectionName) Row \(indexPath.row + 1)"
        
        return cell
    }
    
    // UITableViewDelegate
    
    func tableView(_: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

extension ContestDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_: UIScrollView) {
        let headerViewH = headerView.frame.height
        let panelViewH = panelView.frame.height
        let contentOffsetY = tableView.contentOffset.y
        let contentInsetTop = tableView.contentInset.top
        
        let percentage = (contentOffsetY + contentInsetTop) / headerViewH
        let clampedPercentage = max(0, min(1, percentage))

        let indicatorInsetTop = max(76 + panelViewH, -contentOffsetY)
        let headerViewOpacity = 1 - clampedPercentage
        let headerViewTranslateY = (percentage > 0 ? 0.1 : 0.3) * percentage * headerViewH
        let panelViewTranslateY = (percentage < 1) ? 0 : contentOffsetY + contentInsetTop - headerViewH
        
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(indicatorInsetTop, 0, 0, 0)
        headerView.layer.opacity = Float(headerViewOpacity)
        headerView.layer.transform = CATransform3DMakeTranslation(0, headerViewTranslateY, 0)
        panelView.layer.transform = CATransform3DMakeTranslation(0, panelViewTranslateY, 0)
        countdownView.layer.opacity = Float(headerViewOpacity)
    }
    
}
