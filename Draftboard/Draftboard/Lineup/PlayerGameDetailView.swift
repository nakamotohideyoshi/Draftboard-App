//
//  PlayerGameDetailView.swift
//  Draftboard
//
//  Created by devguru on 4/29/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class PlayerGameDetailView:DraftboardView {
    
    var awayTeamScore = DraftboardLabel()
    var awayTeamCity = DraftboardLabel()
    var awayTeamName = DraftboardLabel()
    var homeTeamScore = DraftboardLabel()
    var homeTeamCity = DraftboardLabel()
    var homeTeamName = DraftboardLabel()
    var atSign = DraftboardLabel()
    var atSignImageView = UIImageView()
    var startTime = DraftboardLabel()
    let bottomBorderView = UIView()
    var game: Game? { didSet { setupGame() } }
    var sportName: String?
    var teamColor: NSDictionary?
    override init() {
        super.init()
        
        if let path = NSBundle.mainBundle().pathForResource("TeamColors", ofType: "plist") {
            teamColor = NSDictionary(contentsOfFile: path)
        }
    }
    
    override func setup() {
        addSubview(awayTeamScore)
        addSubview(awayTeamCity)
        addSubview(awayTeamName)
        addSubview(homeTeamScore)
        addSubview(homeTeamCity)
        addSubview(homeTeamName)
        addSubview(atSign)
        addSubview(atSignImageView)
        addSubview(startTime)
        addSubview(bottomBorderView)
        
        awayTeamScore.font = .oswald(size: 22)
        awayTeamScore.textColor = UIColor(0xc7cfd7)
        awayTeamScore.textAlignment = .Center
        
        awayTeamCity.font = .openSans(weight: .Semibold, size: 9)
        awayTeamCity.textColor = UIColor(0xfbb101)
        awayTeamCity.textAlignment = .Center
        awayTeamCity.letterSpacing = 0.5
        
        awayTeamName.font = .oswald(size: 15)
        awayTeamName.textColor = UIColor(0x942229)
        awayTeamName.textAlignment = .Center
        
        homeTeamScore.font = .oswald(size: 22)
        homeTeamScore.textColor = UIColor(0xc7cfd7)
        homeTeamScore.textAlignment = .Center
        
        homeTeamCity.font = .openSans(weight: .Semibold, size: 9)
        homeTeamCity.textColor = UIColor(0xfbb101)
        homeTeamCity.textAlignment = .Center
        homeTeamCity.letterSpacing = 0.5
        
        homeTeamName.font = .oswald(size: 15)
        homeTeamName.textColor = UIColor(0x942229)
        homeTeamName.textAlignment = .Center
        
        atSign.font = .oswald(weight: .Light, size: 75)
        atSign.textColor = UIColor(0xe6eaef)
        atSign.textAlignment = .Center
        atSign.text = "@"
        atSign.hidden = true
        
        
        atSignImageView.image = UIImage(named: "icon-atsign")
        
        startTime.font = .openSans(weight: .Semibold, size: 10)
        startTime.textColor = UIColor(0x192436)
        startTime.textAlignment = .Center
        
        bottomBorderView.backgroundColor = UIColor(0xd0d2da)
        
        addConstraints()
        
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            awayTeamScore.centerXRancor.constraintEqualToRancor(centerXRancor, multiplierValue: 0.35),
            awayTeamScore.topRancor.constraintEqualToRancor(topRancor),
            awayTeamCity.centerXRancor.constraintEqualToRancor(awayTeamScore.centerXRancor),
            awayTeamCity.topRancor.constraintEqualToRancor(awayTeamScore.bottomRancor),
            awayTeamName.centerXRancor.constraintEqualToRancor(awayTeamScore.centerXRancor),
            awayTeamName.topRancor.constraintEqualToRancor(awayTeamCity.bottomRancor, constant: -awayTeamName.font.ascender + awayTeamName.font.capHeight),
            homeTeamScore.centerXRancor.constraintEqualToRancor(centerXRancor, multiplierValue: 1.65),
            homeTeamScore.topRancor.constraintEqualToRancor(topRancor),
            homeTeamCity.centerXRancor.constraintEqualToRancor(homeTeamScore.centerXRancor),
            homeTeamCity.topRancor.constraintEqualToRancor(homeTeamScore.bottomRancor),
            homeTeamName.centerXRancor.constraintEqualToRancor(homeTeamScore.centerXRancor),
            homeTeamName.topRancor.constraintEqualToRancor(homeTeamCity.bottomRancor, constant: -homeTeamName.font.ascender + homeTeamName.font.capHeight),
            atSign.centerXRancor.constraintEqualToRancor(centerXRancor),
            atSign.topRancor.constraintEqualToRancor(topRancor, constant: -atSign.font.ascender + atSign.font.capHeight + awayTeamScore.font.ascender - awayTeamScore.font.capHeight),
            startTime.centerXRancor.constraintEqualToRancor(centerXRancor),
            startTime.centerYRancor.constraintEqualToRancor(atSign.centerYRancor),
            atSignImageView.centerXRancor.constraintEqualToRancor(centerXRancor),
            atSignImageView.topRancor.constraintEqualToRancor(topRancor, constant: awayTeamScore.font.ascender - awayTeamScore.font.capHeight),
        ]
        awayTeamScore.translatesAutoresizingMaskIntoConstraints = false
        awayTeamCity.translatesAutoresizingMaskIntoConstraints = false
        awayTeamName.translatesAutoresizingMaskIntoConstraints = false
        homeTeamScore.translatesAutoresizingMaskIntoConstraints = false
        homeTeamCity.translatesAutoresizingMaskIntoConstraints = false
        homeTeamName.translatesAutoresizingMaskIntoConstraints = false
        startTime.translatesAutoresizingMaskIntoConstraints = false
        atSign.translatesAutoresizingMaskIntoConstraints = false
        atSignImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let (boundsW, boundsH) = (bounds.width, bounds.height)
        
//        let titleLabelH = titleLabel.sizeThatFits(bounds.size).height
//        let valueLabelH = valueLabel.sizeThatFits(bounds.size).height
//        let combinedH = titleLabelH + 1 + valueLabelH
//        
//        let titleLabelY = fitToPixel(boundsH / 2 - combinedH / 2)
//        let valueLabelY = fitToPixel(titleLabelY + titleLabelH + 1)
//        
//        titleLabel.frame = CGRectMake(0, titleLabelY, boundsW, titleLabelH)
//        valueLabel.frame = CGRectMake(0, valueLabelY, boundsW, valueLabelH)
        bottomBorderView.frame = CGRectMake(0, boundsH - 1 / UIScreen.mainScreen().scale, boundsW, 1 / UIScreen.mainScreen().scale)
    }
    
    func setupGame() {
        awayTeamScore.text = "0"
        awayTeamCity.text = game?.away.city.uppercaseString
        awayTeamName.text = game?.away.name.uppercaseString
        
        homeTeamScore.text = "0"
        homeTeamCity.text = game?.home.city.uppercaseString
        homeTeamName.text = game?.home.name.uppercaseString
        
        let teamColorBySport = teamColor![sportName!] as! NSDictionary
        let awayTeamColor = teamColorBySport[game!.away.srid] as! NSArray
        let homeTeamColor = teamColorBySport[game!.home.srid] as! NSArray
        awayTeamCity.textColor = (awayTeamColor[0] as! String).hexColor
        awayTeamName.textColor = (awayTeamColor[1] as! String).hexColor
        homeTeamCity.textColor = (homeTeamColor[0] as! String).hexColor
        homeTeamName.textColor = (homeTeamColor[1] as! String).hexColor
        
        let df = NSDateFormatter()
        df.dateFormat = "h:mm a"
        startTime.text = df.stringFromDate(game!.start)
        
    }
}

extension String {
    var hexColor: UIColor {
        let hex = self.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        var int = UInt32()
        NSScanner(string: hex).scanHexInt(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return UIColor.clearColor()
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
