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
    @IBOutlet weak var remSalaryLabel: DraftboardLabel!
    @IBOutlet weak var avgSalaryLabel: DraftboardLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var statsDividerHeight: NSLayoutConstraint!
    
    let searchCellIdentifier = "searchCellIdentifier"
    var draftGroup: DraftGroup!
    var players: [Player]!
    var filterBy: String?
    var playerSelectedAction:((Player) -> Void)?
    var positionText: String!
    var loaderView: LoaderView!
    
    init(titleText: String, nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        positionText = titleText
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let draftGroupPromise = Data.draftGroup(id: draftGroup.id)
        let injuriesPromise = Data.sportsInjuries(draftGroup.sport.name)
        draftGroupPromise.then(self.gotDraftGroup)
        when(draftGroupPromise, injuriesPromise).then(self.addInjuryInfo)
        
        view.backgroundColor = .blueDarker()
        
        let onePixel = 1 / UIScreen.mainScreen().scale
        statsDividerHeight.constant = onePixel
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "LineupSearchCellView", bundle: bundle)
        
        tableView.registerNib(nib, forCellReuseIdentifier: searchCellIdentifier)
        tableView.separatorStyle = .None
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clearColor()
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.indicatorStyle = .White
        
        tableView.setContentOffset(CGPointMake(0, searchBar.bounds.size.height), animated: false)
        
        self.showSpinner()
    }
    
    func showSpinner() {
        loaderView = LoaderView(frame: CGRectMake(0, 0, 64, 64))
        
        view.addSubview(loaderView)
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.centerXRancor.constraintEqualToRancor(view.centerXRancor).active = true
        loaderView.centerYRancor.constraintEqualToRancor(view.centerYRancor, constant: -30.0).active = true
        loaderView.heightRancor.constraintEqualToConstant(64.0).active = true
        loaderView.widthRancor.constraintEqualToConstant(64.0).active = true
        
        loaderView.spinning = true
    }
    
    func gotDraftGroup(draftGroup: DraftGroup) {
        self.draftGroup = draftGroup
        self.players = draftGroup.players
        if filterBy != "FX" {
            self.players = self.players.filter { p in p.position == filterBy }
        }
        self.players.sortInPlace { p1, p2 in
            if p1.salary != p2.salary {
                return p1.salary > p2.salary
            }
            if p1.fppg != p2.fppg {
                return p1.fppg > p2.fppg
            }
            return p1.lastName < p2.lastName
        }
        self.loaderView.spinning = false
        self.loaderView.removeFromSuperview()
        self.tableView.reloadData()
    }
    
    func addInjuryInfo(draftGroup: DraftGroup, injuries: [UInt: String]) {
        for player in draftGroup.players! {
            if let injury = injuries[player.id] {
                player.injury = injury
            }
        }
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let players = self.players {
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
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(searchCellIdentifier, forIndexPath: indexPath) as! LineupSearchCellView
        cell.infoButton.addTarget(self, action: Selector("didTapPlayerInfo:"), forControlEvents: .TouchUpInside)
        cell.player = self.players?[indexPath.row]
        cell.backgroundColor = .clearColor()
        cell.topBorder = true
        if indexPath.row == 0 {
            cell.topBorder = false
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 52.0
    }
    
    func didTapPlayerInfo(sender: DraftboardButton) {
        let pdvc = PlayerDetailViewController(nibName: "PlayerDetailViewController", bundle: nil)
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
            navController?.popViewController()
        }
        else if (buttonType == .Search) {
            self.tableView.setContentOffset(CGPointMake(0, 0), animated: true)
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
}
