//
//  MyExt.swift
//  Prototype1
//
//  Created by Acaraga on 17.03.17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import UIKit

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs as Date) == .orderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs as Date) == .orderedAscending
}

extension NSDate: Comparable { }

extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        blurEffectView.tag = 2
        self.addSubview(blurEffectView)
    }
}

func dateFromString(date: String) -> NSDate?
{
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"//this your string date format
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
    let dateRes = dateFormatter.date(from: date)
//    dateFormatter.dateFormat = "yyyy MMM EEEE HH:mm"///this is you want to convert format
//    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
//
//     let timeStamp = dateFormatter.string(from: dateRes!)
//     print ("*** Converted date: \(timeStamp)")
//        //ndCenter.nextTrackCommand.addTarget(self, action:#selector(nextTrackCommandSelector()))
//    } catch let error as NSError {
//        print(error)}
    
    
    return dateRes as NSDate?
}

func convertDateFormatter(date: String) -> String
{
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"//this your string date format
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
    let date = dateFormatter.date(from: date)
    
    
    dateFormatter.dateFormat = "yyyy MMM EEEE HH:mm"///this is you want to convert format
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
    let timeStamp = dateFormatter.string(from: date!)
    
    
    return timeStamp
}
