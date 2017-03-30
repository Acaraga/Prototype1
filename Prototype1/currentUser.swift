//
//  currentUser.swift
//  Prototype1
//
//  Created by Acaraga on 16.03.17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

let ud = userData()
var fireUser: FIRUser? = nil
var currentUserNick = ""
var currentUserEmail = ""
var currentUserKey = ""
var currentUserImage: UIImage?
var currentUserBalance : Float = 0

class userData  {
    var name: String = ""
    var surname: String = ""
  //  var avatarImg: UIImage? =  UIImage.init(named: "#imageLiteral(resourceName: "2_002,")")
}
//

