//
//  ContestListViewController.swift
//  Draftboard
//
//  Created by Anson Schall on 7/26/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit
import PromiseKit

class ContestListViewController: DraftboardViewController {
    
    var contestListView: ContestListView { return view as! ContestListView }
    var sportControl: DraftboardSegmentedControl { return contestListView.sportControl }
    var skillControl: DraftboardSegmentedControl { return contestListView.skillControl }
    var tableView: UITableView { return contestListView.tableView }
    var loaderView: LoaderView { return contestListView.loaderView }
    
    var allContests: [Contest]?
    var sportContests: [String: [Contest]]?
    var skillLevelContests: [String: [Contest]]?
    var contests: [Contest]?
    
    var enteredSkillLevel: String?
    var contestLineups: [Int: [Lineup]]?
    var pendingEntries: [Int: [Promise<[ContestWithEntries]>]] = [:]
    
    override func loadView() {
        self.view = ContestListView()
        tableView.dataSource = self
        tableView.delegate = self
        sportControl.indexChangedHandler = { [weak self] (_: Int) in self?.filterContests() }
        skillControl.indexChangedHandler = { [weak self] (_: Int) in self?.filterContests() }
        update()
    }
    
    override func viewWillAppear(animated: Bool) {
        // Reload what's already there
        sportControl.updateSelectionLine(0, animated: false)
        skillControl.updateSelectionLine(0, animated: false)
        tableView.reloadData()
        // Get contests
        Data.contests.get().then { contests -> Void in
            self.sportControl.choices = self.orderedSports(from: contests)
            self.allContests = self.allContests ?? contests
            self.filterContests()
        }
        
        // Add entry data to contests
        DerivedData.contestsWithEntries().then { contests -> Void in
            self.allContests = contests
            self.filterContests()
        }
        
        when(Data.contests.get(), Data.upcomingLineups.get()).then { contests, lineups -> Void in
            let draftGroupLineups = lineups.groupBy { $0.draftGroupID }
            self.contestLineups = contests.transform([Int: [Lineup]]()) { result, contest in
                result[contest.id] = draftGroupLineups[contest.draftGroupID]
                return result
            }
            self.filterContests()
        }
    }
    
    func orderedSports(from contests: [Contest]) -> [String] {
        let contestSports = Set(contests.map { $0.sportName })
        return Sport.names.filter { contestSports.contains($0) }
    }
    
    func filterContests(reload reload: Bool = true) {
        update()
        
        let sportName = sportControl.choices[safe: sportControl.currentIndex]
        let skillLevel = skillControl.choices[safe: skillControl.currentIndex]
        let sportContests = allContests?.filter { $0.sportName == sportName }
        let enteredContests = sportContests?.filter { ($0 as? HasEntries)?.entries.count > 0 }
        
        contests = sportContests?.filter { $0.skillLevelName == skillLevel }
        enteredSkillLevel = enteredContests?.filter { $0.skillLevelName != "all" }.first?.skillLevelName

        if reload {
            tableView.reloadData()
        }
        
        if enteredSkillLevel != nil && enteredSkillLevel != skillLevel {
            let vc = LockViewController(nibName: "LockViewController", bundle: nil)
            vc.promise.then { _ -> Void in
                RootViewController.sharedInstance.popAlertViewController()
                self.skillControl.updateSelectionLine(self.skillControl.choices.indexOf(self.enteredSkillLevel!)!, animated: true)
            }
            RootViewController.sharedInstance.pushAlertViewController(vc, withBlur: false)
            vc.titleLabel.text = sportControl.choices[sportControl.currentIndex].uppercaseString + " " + skillControl.choices[skillControl.currentIndex].uppercaseString + " lobby locked".uppercaseString
            vc.msgLabel.text = "You are currently entered in one or more " + sportControl.choices[sportControl.currentIndex].uppercaseString + " " + enteredSkillLevel!.capitalizedString + " contests. To enter " + sportControl.choices[sportControl.currentIndex].uppercaseString + " " + skillControl.choices[skillControl.currentIndex].capitalizedString + " contests please deregister from all " + sportControl.choices[sportControl.currentIndex].uppercaseString + " " + enteredSkillLevel!.capitalizedString + " contests."
        }
    }
    
    func update() {
        loaderView.hidden = (allContests != nil)
        tableView.hidden = (allContests == nil)
        sportControl.hidden = (allContests == nil)
        skillControl.hidden = (allContests == nil)
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType? {
        return nil
    }
    
    override func titlebarTitle() -> String? {
        return "Contests".uppercaseString
    }
    
}

// Contest Entry
extension ContestListViewController {
    
    func pickLineup(from lineups: [Lineup]) -> Promise<Lineup> {
        let lineupEntryCount = allContests!.flatMap {
            ($0 as! HasEntries).entries
        }.uniqBy {
            "\($0.contestPoolID)\($0.lineupID)"
        }.countBy {
            $0.lineupID
        }
        
        let mcc = DraftboardModalChoiceController<Lineup>()
        mcc.autopickOnlyOption = true
        mcc.titleText = "Choose an Eligible Lineup"
        mcc.choiceData = lineups.map { Choice(title: $0.name, subtitle: "In \(lineupEntryCount[$0.id] ?? 0) Contests", value: $0) }
        return mcc.promise()
    }
    
    func confirmEntry(to contest: Contest, with lineup: Lineup) -> Promise<Lineup> {
        let entryConfirmationVC = EntryConfirmationViewController()
        entryConfirmationVC.configure(for: contest, lineup: lineup)
        return entryConfirmationVC.promise().then { return Promise(lineup) }
    }
    
    func enterContest(contest: Contest, with lineup: Lineup) -> Promise<[ContestWithEntries]> {
        RootViewController.sharedInstance.popModalViewController()
        
        // Find cell for contest
        let indexPath = NSIndexPath(forRow: contests!.indexOf { $0.id == contest.id }!, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        // Enter
        let pending = contest.enter(with: lineup)
        
        // Save pending reference
        pendingEntries[contest.id] = pendingEntries[contest.id] ?? []
        pendingEntries[contest.id]?.append(pending)
        
        // Show pending status
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)

        // Refresh contest entry info, regardless of success/failure
        pending.always {
            // Remove pending reference
            let i = self.pendingEntries[contest.id]?.indexOf { $0 === pending }
            self.pendingEntries[contest.id]?.removeAtIndex(i!)
            
            DerivedData.contestsWithEntries().then { contests -> Void in
                // Contests with latest entry info
                self.allContests = contests
                self.filterContests(reload: false)
            }.always {
                // Hide pending status
                if self.tableView.cellForRowAtIndexPath(indexPath) == cell {
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                } else {
                    self.tableView.reloadData()
                }
            }
        }
        
        return pending
    }
    
    func enterContest(contest: Contest) -> Promise<[ContestWithEntries]> {
        let entries = (contest as? HasEntries)?.entries
        let lineups = contestLineups?[contest.id]

        // Conditions for entry
        let hasReachedMaxEntries = entries?.count == contest.maxEntries
        let hasEligibleLineups = lineups?.count > 0
        let matchesSkillLevel = contest.matchesSkillLevel(enteredSkillLevel)
        
        guard !hasReachedMaxEntries else { return Promise(error: ContestEntryError.MaxEntered) }
        guard hasEligibleLineups else { return Promise(error: ContestEntryError.NoEligibleLineups) }
        guard matchesSkillLevel else { return Promise(error: ContestEntryError.WrongSkillLevel) }
        
        // Already entered?
        if let enteredLineup = lineups?.filter({ $0.id == entries?.first?.lineupID }).first {
            return enterContest(contest, with: enteredLineup)
        }
        
        // First entry
        return firstly {
            self.pickLineup(from: lineups!)
        }.then { lineup in
            self.confirmEntry(to: contest, with: lineup)
        }.then { lineup in
            self.enterContest(contest, with: lineup)
        }
    }
    
    func showError(error: ErrorType) {
        let error = error as? ContestEntryError ?? ContestEntryError.Unknown
        if (error == .WrongSkillLevel) {
            let vc = LockViewController(nibName: "LockViewController", bundle: nil)
            vc.promise.then { _ -> Void in
                RootViewController.sharedInstance.popAlertViewController()
            }
            RootViewController.sharedInstance.pushAlertViewController(vc, withBlur: false)
            vc.titleLabel.text = sportControl.choices[sportControl.currentIndex].uppercaseString + " " + skillControl.choices[skillControl.currentIndex].uppercaseString + " lobby locked".uppercaseString
            vc.msgLabel.text = "You are currently entered in one or more " + sportControl.choices[sportControl.currentIndex].uppercaseString + " " + enteredSkillLevel!.capitalizedString + " contests. To enter " + sportControl.choices[sportControl.currentIndex].uppercaseString + " " + skillControl.choices[skillControl.currentIndex].capitalizedString + " contests please deregister from all " + sportControl.choices[sportControl.currentIndex].uppercaseString + " " + enteredSkillLevel!.capitalizedString + " contests."
        } else {
            let vc = ErrorViewController(nibName: "ErrorViewController", bundle: nil)
            
            vc.actions = ["OK"]
            vc.promise.then { _ -> Void in
                RootViewController.sharedInstance.popAlertViewController()
            }
            
            RootViewController.sharedInstance.pushAlertViewController(vc)
            vc.titleLabel.text = error.title
            vc.errorLabel.text = error.description
        }
        
    }
    
}

private typealias TableViewDelegate = ContestListViewController
extension TableViewDelegate: UITableViewDataSource, UITableViewDelegate, ContestCellActionButtonDelegate {
    
    // UITableViewDataSource
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contests?.count ?? 0
    }

    func tableView(_: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = ContestCell()
        guard let contest = contests?[safe: indexPath.row] else { return cell }
        
        let entries = (contest as? HasEntries)?.entries
        
        let hasReachedMaxEntries = entries?.count == contest.maxEntries
        let hasEligibleLineups = contestLineups?[contest.id]?.count > 0
        let matchesSkillLevel = contest.matchesSkillLevel(enteredSkillLevel)
        
        let state = ContestCellState()
        state.hasEntries = entries?.count > 0
        state.hasPendingEntries = pendingEntries[contest.id]?.count > 0
        state.canEnter = !hasReachedMaxEntries && hasEligibleLineups && matchesSkillLevel

        cell.showBottomBorder = contest !== contests?.last
        cell.actionButtonDelegate = self
        cell.configure(for: contest, state: state)
        
        return cell
    }
    
    // UITableViewDelegate
    
    func tableView(_: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = ContestDetailViewController()
        detailVC.contest = contests?[safe: indexPath.row]
        navController?.pushViewController(detailVC)
    }
    
    // ContestCellActionButtonDelegate
    
    func actionButtonTappedForCell(cell: ContestCell) {
        guard let indexPath = tableView.indexPathForCell(cell) else { return }
        let contest = contests![indexPath.item]
        if pendingEntries[contest.id]?.count > 0 { return }
        
        enterContest(contest).error { (error: ErrorType) -> Void in
            self.showError(error)
        }
    }

}

enum ContestEntryError: ErrorType {
    case WrongSkillLevel
    case NoEligibleLineups
    case MaxEntered
    case Unknown
}

extension ContestEntryError : CustomStringConvertible {
    var title: String {
        switch self {
        case .WrongSkillLevel: return "Skill Level Unavailable".uppercaseString
        case .NoEligibleLineups: return "No Eligible Lineups".uppercaseString
        case .MaxEntered: return "Max Entered".uppercaseString
        case .Unknown: return "Error".uppercaseString
        }
    }
    var description: String {
        switch self {
        case .WrongSkillLevel: return "You may only enter into 1 skill level per sport."
        case .NoEligibleLineups: return "You have no lineups eligible to enter this contest."
        case .MaxEntered: return "You have the maximum number of entries for this contest."
        case .Unknown: return "Failed to enter contest."
        }
    }
}

private extension Contest {
    func matchesSkillLevel(skillLevelInQuestion: String?) -> Bool {
        if skillLevelInQuestion == nil { return true }
        if skillLevelName == "all" { return true }
        return skillLevelName == skillLevelInQuestion
    }
}
