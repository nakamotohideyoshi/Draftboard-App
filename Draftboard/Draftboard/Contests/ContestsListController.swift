//
//  ContestsListController.swift
//  Draftboard
//
//  Created by Karl Weber on 9/21/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class ContestsListController: DraftboardViewController {
    
    @IBOutlet weak var lineupFilterButton: UIButton!
    @IBOutlet weak var gametypeFilterButton: UIButton!
    
    // Content area (items)
    @IBOutlet weak var contentView: UIView!
    
    var contests: Array<ContestModel> = {
        var array = [ContestModel]()
        array.append(ContestModel())
        array.append(ContestModel())
        array.append(ContestModel())
        array.append(ContestModel())
        return array
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
