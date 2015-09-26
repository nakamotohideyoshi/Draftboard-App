//
//  ContestsListController.swift
//  Draftboard
//
//  Created by Karl Weber on 9/21/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class ContestsListController: DraftboardViewController, UITableViewDelegate, UITableViewDataSource {
    
    let normalContestCellReuseIdentifier   = "normalContestCell"
    let normalContestHeaderReuseIdentifier = "normalHeaderCell"

    @IBOutlet weak var tableView: UITableView!    
    @IBOutlet weak var lineupButton: DraftboardFilterButton!
    @IBOutlet weak var gametypeButton: DraftboardFilterButton!
    
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
        
        self.automaticallyAdjustsScrollViewInsets = false

        tableView.registerClass(DraftboardContestsCell.self, forCellReuseIdentifier: normalContestCellReuseIdentifier)
        tableView.registerClass(ContestsHeaderCell.self, forHeaderFooterViewReuseIdentifier: normalContestHeaderReuseIdentifier)
        
        lineupButton.text = lineups[0].name
        let lineupTapGesture = UITapGestureRecognizer(target: self, action: "switchLineup:")
        lineupButton.addGestureRecognizer(lineupTapGesture)
        let gameTypeTapGesture = UITapGestureRecognizer(target: self, action: "switchGameType:")
        gametypeButton.addGestureRecognizer(gameTypeTapGesture)
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
            print("Cancel")
        }))
        
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    func switchGameType(gesture: UITapGestureRecognizer) {
        let location = gesture.locationInView(gesture.view?.superview)
        print("tap location x:\(location.x) y:\(location.y)")
    }
    
    /*
        UITableViewDatasource
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contests.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(normalContestCellReuseIdentifier, forIndexPath: indexPath) as! DraftboardContestsCell
        
        cell.title?.text = contests[indexPath.row].title
        cell.subtitle?.text = contests[indexPath.row].feeDescription()
        
        if contests[indexPath.row].multientry == true {
            cell.setEntries(contests[indexPath.row].entries)
        } else {
            cell.noEntries()
        }
        
        if contests[indexPath.row].guaranteed == true {
            cell.setGuaranteed()
        } else {
            cell.setNotGuaranteed()
        }

        return cell
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

}
