//
//  ContestsListController.swift
//  Draftboard
//
//  Created by Karl Weber on 9/21/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class ContestsListController: DraftboardViewController, UITableViewDelegate, UITableViewDataSource {
    let normalContestCellReuseIdentifier = "normalContestCell"
    let liveContestCellReuseIdentifier = "liveContestCell"
    let normalContestHeaderReuseIdentifier = "normalHeaderCell"
    
    @IBOutlet weak var tableView: UITableView!    
    @IBOutlet weak var lineupButton: DraftboardFilterButton!
    @IBOutlet weak var gametypeButton: DraftboardFilterButton!
    
    var liveContests: Array<ContestModel> = {
        var array = [ContestModel]()
        array.append(ContestModel(isLive: true))
        array.append(ContestModel(isLive: true))
        array.append(ContestModel(isLive: true))
        array.append(ContestModel(isLive: true))
        array.append(ContestModel(isLive: true))
        array.append(ContestModel(isLive: true))
        return array
        }()
    
    var contests: Array<ContestModel> = {
        var array = [ContestModel]()
        array.append(ContestModel())
        array.append(ContestModel())
        array.append(ContestModel())
        array.append(ContestModel())
        array.append(ContestModel())
        array.append(ContestModel())
        array.append(ContestModel())
        array.append(ContestModel())
        array.append(ContestModel())
        array.append(ContestModel())
        array.append(ContestModel())

        return array
        }()
    
    var lineups: Array<LineupModel> = {
        var array = [LineupModel]()
        array.append(LineupModel())
        array.append(LineupModel())
        array.append(LineupModel())
        array.append(LineupModel())
        return array
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let contestCellNib = UINib(nibName: "DraftboardContestsCell", bundle: bundle)
        let contestHeaderNib = UINib(nibName: "ContestsHeaderCell", bundle: bundle)
        
        tableView.registerNib(contestCellNib, forCellReuseIdentifier: normalContestCellReuseIdentifier)
        tableView.registerNib(contestCellNib, forCellReuseIdentifier: liveContestCellReuseIdentifier)
        tableView.registerNib(contestHeaderNib, forCellReuseIdentifier: normalContestHeaderReuseIdentifier)
        
        /*
        lineupButton.text = lineups[0].name
        let lineupTapGesture = UITapGestureRecognizer(target: self, action: "switchLineup:")
        lineupButton.addGestureRecognizer(lineupTapGesture)
        gametypeButton.text = GameType.Standard.rawValue
        let gameTypeTapGesture = UITapGestureRecognizer(target: self, action: "switchGameType:")
        gametypeButton.addGestureRecognizer(gameTypeTapGesture)
        */
        
        tableView.delegate = self
    }
    
    func switchLineup(gesture: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let numberOfLineups = lineups.count
        for index in 0..<numberOfLineups {
            alert.addAction(UIAlertAction(title: lineups[index].name, style: UIAlertActionStyle.Default, handler: {
                (alert: UIAlertAction!) in
                self.lineupButton.text = self.lineups[index].name
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            (alert: UIAlertAction!) in
        }))
        
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    func switchGameType(gesture: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)

        let arrayOfGametypes = GameType.asArray
        for index in 0..<arrayOfGametypes.count {
            alert.addAction(UIAlertAction(title: arrayOfGametypes[index].rawValue, style: UIAlertActionStyle.Default, handler: {
                (alert: UIAlertAction!) in
                self.gametypeButton.text = arrayOfGametypes[index].rawValue
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            (alert: UIAlertAction!) in
        }))
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    /*
        UITableViewDatasource
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var liveContestsCount = 0
        var contestsCount = 0
        
        if liveContests.count > 0 {
            liveContestsCount = 1
        }
        
        if contests.count > 0 {
            contestsCount = 1
        }
        
        return liveContestsCount + contestsCount
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return liveContests.count
        } else {
            return contests.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // check to see if it is in the live section or not
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(liveContestCellReuseIdentifier, forIndexPath: indexPath) as! DraftboardContestsCell

//            cell.title?.text = liveContests[indexPath.row].title
//            cell.subtitle.hidden = true
//            cell.moneyBar.hidden = false
//            
//            if liveContests[indexPath.row].multientry == true {
//                cell.setEntries(liveContests[indexPath.row].entries)
//            } else {
//                cell.noEntries()
//            }
//            
//            if liveContests[indexPath.row].guaranteed == true {
//                cell.setGuaranteed()
//            } else {
//                cell.setNotGuaranteed()
//            }
//            
//            cell.lineView.hidden = false
//            if indexPath.row == (liveContests.count - 1) {
//                cell.lineView.hidden = true
//            }
//            
//            cell.moneyBar.layoutIfNeeded()
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(normalContestCellReuseIdentifier, forIndexPath: indexPath) as! DraftboardContestsCell
            
//            cell.title?.text = contests[indexPath.row].title
//            cell.subtitle?.text = contests[indexPath.row].feeDescription()
//            cell.subtitle.hidden = false
//            cell.moneyBar.hidden = true
//            
//            if contests[indexPath.row].multientry == true {
//                cell.setEntries(contests[indexPath.row].entries)
//            } else {
//                cell.noEntries()
//            }
//            
//            if contests[indexPath.row].guaranteed == true {
//                cell.setGuaranteed()
//            } else {
//                cell.setNotGuaranteed()
//            }
//            
//            cell.lineView.hidden = false
//            if indexPath.row == (contests.count - 1) {
//                cell.lineView.hidden = true
//            }
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header: ContestsHeaderCell? = tableView.dequeueReusableHeaderFooterViewWithIdentifier(normalContestHeaderReuseIdentifier) as? ContestsHeaderCell
        
        if (header == nil)  {
            header = ContestsHeaderCell(reuseIdentifier: normalContestHeaderReuseIdentifier)
        }
        
        header!.headerTitle?.text = "TODAY"
        header!.headerTitle?.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        header!.contentView.backgroundColor = UIColor(red: 0.098, green: 0.141, blue: 0.211, alpha: 1)
        
        return header!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cdvc = ContestDetailViewController(nibName: "ContestDetailViewController", bundle: nil)
        self.navController?.pushViewController(cdvc)
    }
    
    override func titlebarTitle() -> String? {
        return "Contests".uppercaseString
    }
}
