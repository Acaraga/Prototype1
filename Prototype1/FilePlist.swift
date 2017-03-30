//
//  FilePlist.swift
//  Prototype1
//
//  Created by Acaraga on 25.03.17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
class FilePlist {
    var autoLogin: String? {
        get {
            return UserDefaults.standard.object(forKey: "autoLogin") as! String?
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "autoLogin")
            UserDefaults.standard.synchronize()
        }
    }
    var autoPass: String? {
        get {
            return UserDefaults.standard.object(forKey: "autoPass") as! String?
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "autoPass")
            UserDefaults.standard.synchronize()
        }
    }
    
}
