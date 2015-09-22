//
//  ContestsListController.swift
//  Draftboard
//
//  Created by Karl Weber on 9/21/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class ContestsListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let normalContestCellReuseIdentifier = "normalContestCell"
    
//    @IBOutlet weak var lineupFilterButton: UIButton!
//    @IBOutlet weak var gametypeFilterButton: UIButton!
    
    // Content area (items)
//    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
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

        print("viewDidLoad worked")
        
//        let nibName = UINib(nibName: "DraftboardContestsCell", bundle:nil)
        let nibName = UINib(nibName: "DraftboardContestsCell", bundle: NSBundle.mainBundle())
        
        print("UINib() worked!")
        
//        tableView.registerNib(nibName, forCellReuseIdentifier: normalContestCellReuseIdentifier)
        self.tableView.registerClass(DraftboardContestsCell.self, forCellReuseIdentifier: normalContestCellReuseIdentifier)
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
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        print("cellForRow worked")
        
        let cell = tableView.dequeueReusableCellWithIdentifier(normalContestCellReuseIdentifier, forIndexPath: indexPath) as! DraftboardContestsCell
        
//        if cell == nil {
//            cell = DraftboardContestsCell(style: .Plain, reuseIdentifier: normalContestCellReuseIdentifier)
//        }
        
        cell.title?.text = contests[indexPath.row].title
        cell.subtitle.text = contests[indexPath.row].feeDescription()
        
        cell.backgroundColor = UIColor.draftboardDarkGray()
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contests.count
    }

}
