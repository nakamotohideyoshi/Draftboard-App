//
//  LayoutOne.swift
//  RedMesa
//
//  Created by Karl Weber on 9/9/15.
//  Copyright (c) 2015 Rally Interactive. All rights reserved.
//

import UIKit

class ContestsLayoutOne: UICollectionViewFlowLayout {
   
    var headerAttributes: Array<AnyObject!> = []
    var itemAttributes: Array<AnyObject!> = []
    var allElements: Array<AnyObject!> = []
    var filterAttributes: Array<AnyObject!> = []
    var contentSize: CGSize = CGSizeZero
    private var itemOffset: UIOffset = UIOffsetMake(60.0, 0.0)
    private var rowDimensions: CGSize = CGSizeMake(0.0, 80.0) // width dynamic, height 80.0
    let kRowTypeWide: Int = 0
    let kRowTypeDefault: Int = 1
    private let headerViewKind = "Header"
    private let FilterViewKind = "Filter"
    
    private var oldBounds: CGRect?

    // 99% of the calculations for the layout happens here
    override func prepareLayout() {
        
        self.scrollDirection = .Vertical
        itemAttributes = []
        allElements = []
        filterAttributes = []
        
        let rowXOffset: CGFloat = 60.0
        var yOffset: CGFloat = 0
        var sectionOffset: CGFloat = 0
        let rowHeight: CGFloat = 80.0
        var contentHeight: CGFloat = 0.0
        
        // We'll create a dynamic layout. Each row will have a random number of columns
        // Loop through all the items and calculate the UICollectionViewLayoutAttributes for each one
        rowDimensions = CGSizeMake(self.collectionView!.bounds.size.width - rowXOffset, rowHeight)
        
        let filterwidth = self.collectionView!.bounds.size.width / 2
        print("filterwidth: \(filterwidth)")
        
        // recalculate the buttons frames to fool the collectionview into always including it
        let filterIndexPathOne = NSIndexPath(forItem: 0, inSection: 0)
        let filterAttributesOne = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: "Filter", withIndexPath: filterIndexPathOne)
        filterAttributesOne.zIndex = 2
        filterAttributesOne.frame = CGRectIntegral(CGRectMake(0.0, 0.0, filterwidth, 50.0))
        filterAttributes.append(filterAttributesOne)
        allElements.append(filterAttributesOne)
        
        let filterIndexPathTwo = NSIndexPath(forItem: 0, inSection: 1)
        let filterAttributesTwo = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: "Filter", withIndexPath: filterIndexPathTwo)
        filterAttributesTwo.zIndex = 2
        filterAttributesTwo.frame = CGRectIntegral(CGRectMake(filterwidth, 0.0, filterwidth, 50.0))
        filterAttributes.append(filterAttributesTwo)
        allElements.append(filterAttributesTwo)
        
        // increase the height here
        yOffset = yOffset + 50.0
        contentHeight = yOffset
        sectionOffset = yOffset
        
        // number of sections
        let numberOfSections = collectionView?.numberOfSections()
        
        for index in 0..<numberOfSections! {
            
            var sectionHeight: CGFloat = 0.0
            var rowAttributes: Array<AnyObject!> = []
            
            // this sections rows
            let numberOfRows = collectionView!.numberOfItemsInSection(index)
            for row in 0..<numberOfRows {
                let indexPath = NSIndexPath(forItem: row, inSection: index)
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = CGRectIntegral(CGRectMake(rowXOffset, yOffset, rowDimensions.width, rowDimensions.height))
                attributes.zIndex = 1
                rowAttributes.append(attributes)
                allElements.append(attributes)
                sectionHeight = sectionHeight + attributes.frame.size.height
                yOffset = yOffset + attributes.frame.size.height
            }
            itemAttributes.append(rowAttributes)
            
            let indexPath = NSIndexPath(forItem: 0, inSection: index)
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: "Header", withIndexPath: indexPath)
            attributes.frame = CGRectIntegral(CGRectMake(0.0, sectionOffset, self.collectionView!.bounds.size.width, sectionHeight))
            attributes.zIndex = 0
            allElements.append(attributes)
            headerAttributes.append(attributes)
            // reset and increment the section height and stuff.
            sectionOffset = sectionOffset + sectionHeight
            contentHeight = contentHeight + sectionHeight
            sectionHeight = 0
        }


        
        // the contentSize Determines how it scrolls
        // so if its width is the same as the screen
        // then it will only scroll vertically.
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        
        // Return this in collectionViewContentSize
        contentSize = CGSizeMake(screenWidth, contentHeight) // We add 49.00 because we have a tabbar controller.
        oldBounds = screenRect
    }
    
    override func collectionViewContentSize() -> CGSize {
        return contentSize
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes {
        return itemAttributes[indexPath.row] as! UICollectionViewLayoutAttributes
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes {
        
        if elementKind == FilterViewKind {
            return filterAttributes[indexPath.section] as! UICollectionViewLayoutAttributes
        } else {
            // headerViewKind
            return headerAttributes[indexPath.section] as! UICollectionViewLayoutAttributes
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return allElements.filter({
            (includedElement: AnyObject!) -> Bool in
            
            if let kind = includedElement.representedElementKind {
                if kind == FilterViewKind {
                    let offset = self.collectionView!.contentOffset.y
                    let filterAttributes = includedElement as! UICollectionViewLayoutAttributes
                    filterAttributes.frame = CGRectMake(filterAttributes.frame.origin.x, offset, filterAttributes.frame.width, filterAttributes.frame.height)
                }
            }
            if includedElement.frame != nil {
                return CGRectIntersectsRect(rect, includedElement.frame)
            }
            return false
        }) as? [UICollectionViewLayoutAttributes]
    }
    
    // called a ton when we scroll
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        var invalidate = false
        for filtr in filterAttributes {
            if filtr.frame != nil {
                invalidate = !CGRectIntersectsRect(newBounds, filtr.frame)
            }
        }
        if !CGRectEqualToRect(self.oldBounds!, newBounds) {
            invalidate = true
        }
        return invalidate
    }

}
