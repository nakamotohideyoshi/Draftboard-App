//
//  LineupNewViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/16/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit
import PromiseKit

class LineupSearchViewController: DraftboardViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let searchCellIdentifier = "searchCellIdentifier"
    var draftGroup: DraftGroup!
    var players: [Player]!
    var filterBy: String?
    var playerSelectedAction:((Player) -> Void)?
    var positionText: String!
    var loaderView: LoaderView!
    var searchTextField: UITextField?
    var replacingPlayer: Player?
    
    var statRemSalary: Double = 0
    var statAvgSalary: Double = 0
    var lineup: Lineup
    
    init(titleText: String, lineup _lineup: Lineup, nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        lineup = _lineup
        positionText = titleText
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let draftGroupPromise = API.draftGroup(id: draftGroup.id)
        let injuriesPromise = API.sportsInjuries(draftGroup.sport.name)
        draftGroupPromise.then { draftGroup in
            self.gotDraftGroup(draftGroup)
        }
        when(draftGroupPromise, injuriesPromise).then { (draftGroup, injuries) in
            self.addInjuryInfo(draftGroup, injuries: injuries)
        }
        
        view.backgroundColor = .blueDarker()
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "LineupSearchCellView", bundle: bundle)
        
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        
        tableView.registerNib(nib, forCellReuseIdentifier: searchCellIdentifier)
        tableView.separatorStyle = .None
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clearColor()
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.indicatorStyle = .White
        
        tableView.setContentOffset(CGPointMake(0, searchBar.bounds.size.height), animated: false)
        
        loaderView = LoaderView(frame: CGRectZero)
        loaderView.spinning = true
        view.addSubview(loaderView)
        constrainLoader()
        
        showLoader()
    }
    
    func updateStats() {
        let playersRemaining = lineup.players.filter {$0 == nil}.count
        statRemSalary = lineup.sport.salary - lineup.salary
        statAvgSalary = (playersRemaining > 0) ? statRemSalary / Double(playersRemaining) : 0
        
        if let rp = replacingPlayer {
            statRemSalary += rp.salary
        }
    }
    
    func constrainLoader() {
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.centerXRancor.constraintEqualToRancor(view.centerXRancor).active = true
        loaderView.centerYRancor.constraintEqualToRancor(view.centerYRancor, constant: 38.0 - 30.0).active = true
        loaderView.heightRancor.constraintEqualToConstant(42.0).active = true
        loaderView.widthRancor.constraintEqualToConstant(42.0).active = true
    }
    
    func showLoader() {
        tableView.hidden = true
        loaderView.hidden = false
    }
    
    func hideLoader() {
        tableView.hidden = false
        loaderView.hidden = true
    }
    
    func reloadData() {
        if let _ = draftGroup {
            self.updatePlayers()
            self.tableView.reloadData()
            hideLoader()
        }
        else {
            showLoader()
        }
    }
    
    func gotDraftGroup(draftGroup: DraftGroup) {
        self.draftGroup = draftGroup
        
        self.updatePlayers()
        self.tableView.reloadData()
        self.scrollToFirstAffordablePlayer()
        
        self.hideLoader()
    }
    
    func scrollToFirstAffordablePlayer() {
        var idx = 0
        for player in players {
            if player.salary > statRemSalary {
                idx++
            }
            else {
                break
            }
        }
        
        if idx < players.count {
            if idx > 0 {
                idx--
            }
            
            let indexPath = NSIndexPath(forRow: idx, inSection: 0)
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
            tableView.flashScrollIndicators()
        }
    }
    
    func updatePlayers() {
        players = draftGroup.players
        
        // Filter by position
        if filterBy != "FX" {
            players = players.filter { p in p.position == filterBy }
        }
        
        // Filter by search text
        let searchText = searchBar.text ?? ""
        if searchText != "" {
            let searchWords = searchText.lowercaseString.componentsSeparatedByString(" ")
            if searchWords.count > 0 {
                players = players.filter { player in
                    for component in searchWords {
                        let firstname = player.firstName.lowercaseString
                        let lastName = player.lastName.lowercaseString
                        if firstname.hasPrefix(component) || lastName.hasPrefix(component) {
                            return true
                        }
                    }
                    return false
                }
            }
        }
        
        // Sort by salary, fppg, name
        players.sortInPlace { p1, p2 in
            if p1.salary != p2.salary {
                return p1.salary > p2.salary
            }
            if p1.fppg != p2.fppg {
                return p1.fppg > p2.fppg
            }
            return p1.lastName < p2.lastName
        }
    }
    
    func addInjuryInfo(draftGroup: DraftGroup, injuries: [Int: String]) {
        for player in draftGroup.players {
            if let injury = injuries[player.id] {
                player.injury = injury
            }
        }
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let players = self.players {
            self.view.endEditing(true)
            let player = players[indexPath.row]
            playerSelectedAction?(player)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let players = self.players {
            return players.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let player = self.players?[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(searchCellIdentifier, forIndexPath: indexPath) as! LineupSearchCellView
        cell.bigInfoButton.addTarget(self, action: Selector("didTapPlayerInfo:"), forControlEvents: .TouchUpInside)
        cell.player = player
        
        cell.topBorder = true
        cell.backgroundColor = .clearColor()
        
        if player?.salary > statRemSalary {
            cell.overBudget = true
        }
        else {
            cell.overBudget = false
        }
    
        if indexPath.row == 0 {
            cell.topBorder = false
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 52.0
    }
    
    func didTapPlayerInfo(sender: DraftboardButton) {
        let cell = sender.superview as? LineupSearchCellView
        let pdvc = PlayerDetailViewController(nibName: "PlayerDetailViewController", bundle: nil)
        pdvc.player = cell?.player
        self.navController?.pushViewController(pdvc)
    }
    
    override func titlebarTitle() -> String? {
        return positionText.uppercaseString
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Value) {
            navController?.popViewController()
        }
        else if(buttonType == .Back) {
            self.view.endEditing(true)
            navController?.popViewController()
        }
        else if (buttonType == .Search) {
            if self.tableView.contentOffset.y == 0 {
                self.searchBar.becomeFirstResponder()
            }
            else {
                self.tableView.setContentOffset(CGPointMake(0, 0), animated: true)
            }
        }
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType {
        return .Back
    }
    
    override func titlebarRightButtonType() -> TitlebarButtonType {
        return .Search
    }
    
    override func titlebarBgHidden() -> Bool {
        return false
    }
    
    override func footerType() -> FooterType {
        return .Stats
    }
}

extension LineupSearchViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 && !searchBar.isFirstResponder() {
            searchBar.becomeFirstResponder()
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate && scrollView.contentOffset.y == 0 && !searchBar.isFirstResponder() {
            searchBar.becomeFirstResponder()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 && !searchBar.isFirstResponder() {
            searchBar.becomeFirstResponder()
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let searchFirstResponder = self.searchBar.isFirstResponder()
        let searchOffScreen = scrollView.contentOffset.y >= self.searchBar.frame.size.height
        if searchFirstResponder && searchOffScreen {
            self.searchBar.resignFirstResponder()
        }
    }
}

extension LineupSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if players.count > 0 {
            searchBar.resignFirstResponder()
            if players.count == 1 {
                playerSelectedAction?(players.first!)
            }
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        updatePlayers()
        
        if players.count == 0 {
            tableView.scrollEnabled = false
            searchBar.returnKeyType = .Default
        }
        else if players.count == 1 {
            tableView.scrollEnabled = true
            searchBar.returnKeyType = .Go
        }
        else {
            tableView.scrollEnabled = true
            searchBar.returnKeyType = .Search
        }
        
        tableView.reloadData()
        searchBar.resignFirstResponder()
        searchBar.becomeFirstResponder()
    }
}

extension LineupSearchViewController: StatFooterDataSource {
    
    func footerStatAvgSalary() -> Double? {
        if (statAvgSalary < 0) {
            return 0.0
        }
        
        return statAvgSalary
    }
    
    func footerStatRemSalary() -> Double? {
        return statRemSalary
    }
    
    func footerStatLiveInDate() -> NSDate? {
        return lineup.draftGroup.start
    }
}
