//
//  EntryConfirmationViewController.swift
//  Draftboard
//
//  Created by Anson Schall on 8/26/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit
import PromiseKit

class EntryConfirmationViewController: DraftboardModalViewController {
    
    var entryConfirmationView: EntryConfirmationView { return view as! EntryConfirmationView }
    var titleLabel: UILabel { return entryConfirmationView.titleLabel }
    var confirmationLabel: UILabel { return entryConfirmationView.confirmationLabel }
    var prizeStatView: ModalStatView { return entryConfirmationView.prizeStatView }
    var entrantsStatView: ModalStatView { return entryConfirmationView.entrantsStatView }
    var feeStatView: ModalStatView { return entryConfirmationView.feeStatView }
    var dontAskSwitch: UISwitch { return entryConfirmationView.dontAskSwitch }
    var enterButton: UIButton { return entryConfirmationView.enterButton }
    var cancelButton: UIButton { return entryConfirmationView.cancelButton }

    let (pendingPromise, fulfill, reject) = Promise<Void>.pendingPromise()
    
    override func loadView() {
        view = EntryConfirmationView()
        enterButton.addTarget(self, action: #selector(tappedEnterButton), forControlEvents: .TouchUpInside)
        cancelButton.addTarget(self, action: #selector(tappedCancelButton), forControlEvents: .TouchUpInside)
    }
    
    func promise() -> Promise<Void> {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey(App.DefaultsDontAskToConfirmEntry) {
            fulfill()
            return pendingPromise
        }
        
        RootViewController.sharedInstance.pushModalViewController(self)
        return pendingPromise
    }
        
    func configure(for contest: Contest, lineup: Lineup) {
        confirmationLabel.text = contest.name.uppercaseString
        prizeStatView.valueLabel.text = Format.currency.stringFromNumber(contest.prizePool)
        entrantsStatView.valueLabel.text = "\(contest.currentEntries)"
        feeStatView.valueLabel.text = Format.currency.stringFromNumber(contest.buyin)
        enterButton.setTitle("Enter “\(lineup.name)”".uppercaseString, forState: .Normal)
    }
    
    func tappedEnterButton() {
        if dontAskSwitch.on {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(true, forKey: App.DefaultsDontAskToConfirmEntry)
        }

        fulfill()
    }
    
    func tappedCancelButton() {
        RootViewController.sharedInstance.popModalViewController()
        reject(ModalError.Cancelled)
    }
}
