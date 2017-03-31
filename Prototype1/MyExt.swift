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


extension Notification.Name {
    static let notificationFromChatVC = Notification.Name(rawValue: "notificationFromChatVC")
    
}


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

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
