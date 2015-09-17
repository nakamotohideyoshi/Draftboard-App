//
//  ContestsViewController.swift
//  
//
//  Created by Karl Weber on 9/9/15.
//
//

import UIKit

let reuseIdentifier = "Cell"

class ContestsViewController: UICollectionViewController {

    private let reuseIdentifier = "CellOne"
    private let headerReuseIdentifier = "ContestHeader"
    private let headerViewKind = "Header"
    private let filterReuseIdentifier = "FilterHeader"
    private let FilterViewKind = "Filter"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    var contests = [ContestRow]() // data
    var headers: Array<AnyObject!> = [] // stored cells
    var filters = [String]() // data
    var filtersViews: Array<AnyObject!> = [] // stored cells
    
    var availableLineups = [String]()
    var chosenLineup: Int = 0
    var activeRows = [NSIndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNeedsStatusBarAppearanceUpdate()
        
        self.title = "Contests"
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().translucent = false
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        self.collectionView!.backgroundColor = .draftColorDarkBlue()
        
        self.collectionView!.delegate = self
        self.collectionView!.dataSource = self
        self.collectionView!.showsVerticalScrollIndicator = false
        
        buildTheData()
        buildTheButtons()
        buildTheLineups()

        // Register cell classes
        self.collectionView!.registerClass(CellOne.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Register header views
        self.collectionView!.registerClass(HeaderViewOne.self, forSupplementaryViewOfKind: headerViewKind, withReuseIdentifier: headerReuseIdentifier)
        
        // Register filter views
        self.collectionView!.registerClass(ContestFilterButton.self, forSupplementaryViewOfKind: FilterViewKind, withReuseIdentifier: filterReuseIdentifier)
    }

    func buildTheData() {
        var group1items = Array<String>()
        group1items.append("feed the cat")
        group1items.append("clean the cat")
        group1items.append("get a dog")
        group1items.append("I already have a dog")
        group1items.append("more stuff")
        let group1 = ContestRow(text: "9:32", items: group1items)
        contests.append(group1)
        
        var group2items = [String]()
        group2items.append("feed the cat")
        group2items.append("feed the cat")
        group2items.append("feed the cat")
        group2items.append("feed the cat")
        group2items.append("feed the cat")
        group2items.append("feed the cat")
        let group2 = ContestRow(text:"5 hrs", items: group2items)
        contests.append(group2)
        
        var group3items = [String]()
        group3items.append("eat the cat")
        group3items.append("eat the cat")
        group3items.append("eat the cat")
        group3items.append("eat the cat")
        group3items.append("eat the cat")
        group3items.append("eat the cat")
        let group3 = ContestRow(text: "1 day", items: group3items)
        contests.append(group3)
    }
    
//    func buildTheButtons(){
//        filters.append("Warriors Stack")
//        filters.append("All GameTypes")
//    }
    
    func buildTheLineups() {
        availableLineups.append("Warriors Stack")
        availableLineups.append("Warriors Stack 2")
        availableLineups.append("Neutron Power")
        availableLineups.append("Marvel")
        availableLineups.append("DC")
    }
    
    func totalrows() -> Int {
        
        var total = 0
        for index in 0..<self.contests.count {
            for _ in 0..<self.contests[index].items.count {
                total = total + 1
            }
        }
        return total
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        collectionView!.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return contests.count
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contests[section].items.count
    }

    // animation will happen here.
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> CellOne {
        let cell: CellOne = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CellOne

        cell.titleLabel.text = "$100-Free Roll"
        cell.subLabel.text = "$10 Fee / $100 Prizes"
        cell.currentIndexPath = indexPath
        cell.setContainingCollectionView(self.collectionView!)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        print("Supplementary kind: \(kind)")
        
        if kind == FilterViewKind {

            let cell = collectionView.dequeueReusableSupplementaryViewOfKind(FilterViewKind, withReuseIdentifier: filterReuseIdentifier, forIndexPath: indexPath) as! ContestFilterButton
            maybeAddAFilter(cell)
            
            if indexPath.section == 0 { 
                cell.filterButton.addTarget(self, action: "filterLineups:", forControlEvents: .TouchUpInside)
                cell.filterButton.setTitle(availableLineups[chosenLineup], forState: .Normal)
            } else {
                cell.filterButton.addTarget(self, action: "filterGameTypes:", forControlEvents: .TouchUpInside)
                cell.filterButton.setTitle(filters[indexPath.section], forState: .Normal)
            }
            return cell
        } else {
            // headerViewKind
            let cell = collectionView.dequeueReusableSupplementaryViewOfKind(headerViewKind, withReuseIdentifier: headerReuseIdentifier, forIndexPath: indexPath) as! HeaderViewOne
            maybeAddAHeader(cell)
            cell.titleLabel.text = contests[indexPath.section].title
            cell.backgroundColor = .whiteColor()
            return cell
        }
    }
    
    // on tapping the filters
    func filterLineups(sender: UIButton!) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let numberOfLineups = availableLineups.count
        for index in 0..<numberOfLineups {
            alert.addAction(UIAlertAction(title: availableLineups[index], style: UIAlertActionStyle.Default, handler: {
                (alert: UIAlertAction!) in
                let button = self.filtersViews[0] as! ContestFilterButton
                button.filterButton.setTitle(self.availableLineups[index], forState: .Normal)
                self.chosenLineup = index
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            (alert: UIAlertAction!) in
            print("Cancel")
        }))
        
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    // on tapping the filters
    func filterGameTypes(sender: UIButton!) {
        
    }
    
    // on scroll
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
//        self.collectionViewLayout.invalidateLayout()
        
            //invalidateSupplementaryElementsOfKind("Filter", atIndexPaths: [NSIndexPath(forRow: 0, inSection: 0),NSIndexPath(forRow: 0, inSection: 1)])
        
        let cutoffHeaders = getHeadersAboveTop() as! [HeaderViewOne]
        
        // iterate over each header
        for header in cutoffHeaders {
            // check if the the header point x point is above the scroll y offset
            if header.frame.origin.y  < (collectionView!.contentOffset.y + 50) {
                
                // adjust the titleLabel's frame to be just below the top, but never below the frame
                // also just below the other buttons
                var yOffset = (collectionView!.contentOffset.y) - header.frame.origin.y + 50
                
                if yOffset > (header.frame.size.height ) {
                    yOffset = header.frame.size.height
                }
                
                header.titleLabel.frame = CGRectMake(0, yOffset, header.titleLabel.frame.size.width, header.titleLabel.frame.size.height)
            } else {
                header.titleLabel.frame = CGRectMake(0, 0, header.titleLabel.frame.size.width, header.titleLabel.frame.size.height)
            }
        }
        
        // for filter buttons
        for filterView in filtersViews {
            let filterthingy = filterView as! ContestFilterButton
            filterthingy.frame = CGRectMake(filterthingy.frame.origin.x, collectionView!.contentOffset.y, filterthingy.frame.size.width, filterthingy.frame.size.height)
        }
    }
    
    /*
        This stuff makes the headers have sticky titleLabels.
    */
    func getHeadersAboveTop() -> [UICollectionReusableView] {
        
        let width = collectionView!.frame.width
        let height = collectionView!.frame.height
        let rect = CGRectMake(0, 0 + collectionView!.contentOffset.y, width, height)
        
        return headers.filter({
            (includedElement: AnyObject!) -> Bool in
            if includedElement.frame != nil {
                return CGRectIntersectsRect(rect, includedElement.frame)
            }
            return false
        }) as! [UICollectionReusableView]
    }
    
    func maybeAddAHeader(header: UICollectionReusableView) {
        var add = true
        for object in headers {
            if CGRectEqualToRect(object.frame, header.frame) {
                add = false
            }
        }
        if add {
            headers.append(header)
        }
    }
    
    func maybeAddAFilter(filter: UICollectionReusableView) {
        var add = true
        for object in filtersViews {
            if CGRectEqualToRect(object.frame, filter.frame) {
                add = false
            }
        }
        if add {
            filtersViews.append(filter)
        }
    }

}
