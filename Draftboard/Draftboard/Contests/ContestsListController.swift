//
//  ContestsListController.swift
//  Draftboard
//
//  Created by Karl Weber on 9/21/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class ContestsListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let normalContestCellReuseIdentifier   = "normalContestCell"
    let normalContestHeaderReuseIdentifier = "normalHeaderCell"
    
//    @IBOutlet weak var lineupFilterButton: UIButton!
//    @IBOutlet weak var gametypeFilterButton: UIButton!
    
    // Content area (items)
//    @IBOutlet weak var contentView: UIView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false

        tableView.registerClass(DraftboardContestsCell.self, forCellReuseIdentifier: normalContestCellReuseIdentifier)
        tableView.registerClass(ContestsHeaderCell.self, forHeaderFooterViewReuseIdentifier: normalContestHeaderReuseIdentifier)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 46, 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
        UITableViewDelegate
    */
    
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
            print("true")
            cell.setEntries(contests[indexPath.row].entries)
        } else {
            print("false")
            cell.noEntries()
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














