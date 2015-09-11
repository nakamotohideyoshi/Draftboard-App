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
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private var headers: Array<AnyObject!> = []
    var lineupButton: UIButton = UIButton()
    var gameTypeButton: UIButton = UIButton()
    
    var contests = [ContestRow]()
    
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

        // Register cell classes
        self.collectionView!.registerClass(CellOne.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Register header views
        self.collectionView!.registerClass(HeaderViewOne.self, forSupplementaryViewOfKind: headerViewKind, withReuseIdentifier: headerReuseIdentifier)
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
    
    func buildTheButtons(){
        
        let width = self.view.bounds.width / 2
        let height: CGFloat = 50.0
        
        lineupButton   = UIButton(frame: CGRectMake(0, 0, width, height))
        gameTypeButton = UIButton(frame: CGRectMake(width, 0, width, height))
        
        lineupButton.titleLabel?.textAlignment = .Center
        lineupButton.titleLabel?.textColor = .whiteColor()
        lineupButton.titleLabel?.text = "Warriors Stack"
        gameTypeButton.titleLabel?.textAlignment = .Center
        gameTypeButton.titleLabel?.textColor = .whiteColor()
        gameTypeButton.titleLabel?.text = "All GameTypes"
    }
    
    func setLineupButtonText(text: String) {
        lineupButton.titleLabel?.text = text
    }
    
    func setgameTypeButtonText(text: String) {
        lineupButton.titleLabel?.text = text
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
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        print("Supplementary kind: \(kind)")
        
        let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerReuseIdentifier, forIndexPath: indexPath) as! HeaderViewOne
        
        maybeAddAHeader(cell)
        
        // do stuff
        cell.titleLabel.text = contests[indexPath.section].title

        cell.backgroundColor = .whiteColor()
//        cell.backgroundColor = .grayColor()
//        if indexPath.section % 2 == 0 {
//            cell.backgroundColor = .lightGrayColor()
//        }
        
        return cell
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let cutoffHeaders = getHeadersAboveTop() as! [HeaderViewOne]
        
        // iterate over each header
        for header in cutoffHeaders {
            
            print("header.frame.origin.y: \(header.frame.origin.y), collectionView!.contentOffset.y: \(collectionView!.contentOffset.y)")
            
            // check if the the header point x point is above the scroll y offset
            if header.frame.origin.y < (collectionView!.contentOffset.y) {
                
                // adjust the titleLabel's frame to be just below the top, but never below the frame
                var yOffset = (collectionView!.contentOffset.y) - header.frame.origin.y
                
                if yOffset > (header.frame.size.height - 50) {
                    yOffset = header.frame.size.height - 50
                }
                
                print("yOffset: \(yOffset)")
                header.titleLabel.frame = CGRectMake(0, yOffset, header.titleLabel.frame.size.width, header.titleLabel.frame.size.height)
            } else {
                header.titleLabel.frame = CGRectMake(0, 0, header.titleLabel.frame.size.width, header.titleLabel.frame.size.height)
            }
        }
    }
    
    /*
        This stuff makes the headers have sticky titleLabels.
    */
    func getHeadersAboveTop() -> [UICollectionReusableView] {
        
        let width = collectionView!.frame.width
        let height = collectionView!.frame.height
        let rect = CGRectMake(0, 0 + collectionView!.contentOffset.y, width, height)
        
//        print(" x: \(collectionView!.contentOffset.x), y: \(collectionView!.contentOffset.y), width: \(width), height: \(height)")
        
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

}
