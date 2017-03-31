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

//============вычисление баланса пользователя по ключу===================
func getUserBalanceByKey (key: String, complition: @escaping (Float) -> ()) -> () {
//=======================================================================
    var sumBalance: Float = 0
    
    FIRDatabase.database().reference().child("operations/\(key)").observe(.value, with: { (snapshot) in
        
        if let u_value = snapshot.value {
            sumBalance = 0
            let json = JSON (u_value)
            for (_, subjson) in json {
                //print (subjson)
                sumBalance += subjson["scoresDelta"].floatValue
            }
        }
        complition (sumBalance)
        print ("*** AND The Balance for me is: \(sumBalance)")
    })
}

//============вычисление  tokenFCM пользователя по ключу===================
func getUserFCMTokenByKey (key: String, complition: @escaping (String) -> ()) -> () {
//=======================================================================
    var tokenFCM = ""
    var lastDate = ""
    FIRDatabase.database().reference().child("users/\(key)/tokenFCM").observeSingleEvent(of: .value, with: { (snapshot) in
        
        if let u_value = snapshot.value {
            let json = JSON (u_value)
            lastDate = json["date"].stringValue
            tokenFCM = json["token"].stringValue
        }
        complition (tokenFCM)
        print ("*** Found tokenFCM: \(tokenFCM)")
        print ("*** Last Login: \(lastDate)")
    })
}
