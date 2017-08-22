//
//  UIColor+DraftboardColors.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/18/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

typealias DraftboardColor = UIColor

extension UIColor {
    
    convenience init(_ hex:UInt32, alpha:CGFloat = 1.0) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let b = CGFloat(hex & 0xFF) / 255.0
        self.init(red:r, green:g, blue:b, alpha:alpha)
    }
    
    //
    // MARK: - Draftboard colors
    //
    
    // Reference "DB Style guide.psd" for further color examples and explanation
    
    // Used for grey type across the app that isn't
    // white with an alpha component
    class func greyCool() -> UIColor {
        return UIColor(0x4b545f)
    }
    
    // The brand green for draftboard This is used as an accent color
    // AND represents money
    class func greenDraftboard() -> UIColor {
        return UIColor(0x26C661)
    }
    
    // The brand green in a less bright state to be used ONLY for highlight and selected states
    class func greenDraftboardDarker() -> UIColor {
        return UIColor(0x21A250)
    }
    
    // High saturation accent blue that is sparingly used to represent LIVE games and PMR
    class func blueAccent() -> UIColor {
        return UIColor(0x3381FF)
    }
    
    // Background blue color used on the sticky header background and the lineup card background
    class func blueMediumDark() -> UIColor {
        return UIColor(0x1f2d47)
    }
    
    // Background blue color used on the tab bar
    class func blueDark() -> UIColor {
        return UIColor(0x1f2d47)
    }
    
    // Background blue color used on the background of table views
    class func blueDarker() -> UIColor {
        return UIColor(0x101722)
    }
    
    // Only used for injured status
    class func redDraftboard() -> UIColor {
        return UIColor(0xe42e2f)
    }
    
    class func orangeDraftboard() -> UIColor {
        return UIColor(0xe88214)
    }
    
    //
    // MARK: - Specific color implementations
    //
    
    // Dividers on white color
    class func dividerOnWhiteColor() -> UIColor {
        return UIColor(0xe6e8ed)
    }
    
    class func dividerOnDarkColor() -> UIColor {
        return dividerOnWhiteColor().colorWithAlphaComponent(0.1)
    }
    
    // PMR color
    class func PMRColorFG() -> UIColor {
        return blueAccent()
    }
    
    class func PMRColorBG() -> UIColor {
        return UIColor(0x273956)
    }
    
    // Background color for table cells
    class func cellColorDark() -> UIColor {
        return blueDarker()
    }
    
    // Selected color for dark blue table cells
    class func cellColorDarkSelected() -> UIColor {
        return UIColor(0x1a2537)
    }
    
    // Background color for table sticky header cells
    class func headerColorDark() -> UIColor {
        return blueMediumDark()
    }
    
    // Tab bar background color
    class func tabBarColor() -> UIColor {
        return blueDark()
    }
    
    // Lineup card background color
    class func cardColor() -> UIColor {
        return blueMediumDark()
    }
    
    class func injuredColor() -> UIColor {
        return redDraftboard()
    }
    
    class func buttonDisabledBackground() -> UIColor {
        return greyCool()
    }
    
    class func footerViewColor() -> UIColor {
        return UIColor(0x152133, alpha: 0.9)
    }
    
    class func lineupStatTitleColor(style: LineupStatStyle) -> UIColor {
        return greyCool()
    }
    
    class func lineupStatValueColor(style: LineupStatStyle) -> UIColor {
        return whiteColor()
    }
    
    class func lineupStatTimeColor(style: LineupStatStyle) -> UIColor {
        return greyCool()
    }
    
    class func lineupStatFeesColor(style: LineupStatStyle) -> UIColor {
        return greyCool()
    }
    
    //
    // MARK: - Opacities
    //
    
    // Only used for certain typographic situations
    class func whiteHighOpacity() -> UIColor {
        return whiteColor().colorWithAlphaComponent(0.8)
    }
    
    // Only used for certain typographic situations (most common)
    class func whiteMediumOpacity() -> UIColor {
        return whiteColor().colorWithAlphaComponent(0.6)
    }
    
    // Only used for certain typography situations (most rare)
    class func whiteLowOpacity() -> UIColor {
        return whiteColor().colorWithAlphaComponent(0.4)
    }
    
    // Only used for horizontal table cell dividers and 1px highlights
    class func whiteLowestOpacity() -> UIColor {
        return whiteColor().colorWithAlphaComponent(0.1)
    }
    
    //
    // TODO: Remove extraneous money graph colors
    //
    //  - Only blue on PMR pie chart
    //  - Only greenDraftboard when "in the money"
    //
    
    // MARK: - Pie chart colors
    
    class func moneyRangeBackground() -> UIColor {
        return UIColor(red: 94/255, green: 106/255, blue: 127/255, alpha: 0.2)
    }
    
    class func moneyBrightBackground() -> UIColor {
        return UIColor(red: 36/255, green: 48/255, blue: 67/255, alpha: 1)
    }
    
    class func moneyDarkBackground() -> UIColor {
        return whiteLowestOpacity()
    }

    class func moneyGray() -> UIColor {
        return UIColor(red: 94/255, green: 106/255, blue: 127/255, alpha: 1)
    }

    class func moneyBlue() -> UIColor {
        return UIColor.blueAccent()
    }
    
    class func moneyDarkBlue() -> UIColor {
        return UIColor(red: 0, green: 162/255, blue: 255/255, alpha: 0.2)
    }

    class func moneyGreen() -> UIColor {
        return UIColor.greenDraftboard()
    }
    
    class func moneyDarkGreen() -> UIColor {
        return UIColor.greenDraftboard().colorWithAlphaComponent(0.1)
    }
    
    class func moneyYellow() -> UIColor {
        return UIColor.greenDraftboard()
    }
    
    class func moneyDarkYellow() -> UIColor {
        return UIColor.greenDraftboard().colorWithAlphaComponent(0.1)
    }

    class func moneyRed() -> UIColor {
        return UIColor.greenDraftboard()
    }
    
    class func moneyDarkRed() -> UIColor {
        return UIColor.greenDraftboard().colorWithAlphaComponent(0.1)
    }
}
