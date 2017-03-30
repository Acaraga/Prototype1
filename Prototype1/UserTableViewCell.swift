//
//  UserTableViewCell.swift
//  Prototype1
//
//  Created by Acaraga on 20.03.17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var imgBG: UIImageView!
    @IBOutlet weak var lblLogin: UILabel!
    
    @IBOutlet weak var lblEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let screenW = UIScreen.main.bounds.width
        contentView.frame = CGRect(x: 0, y: 0, width: screenW, height: 100)
        imgProfile.center = CGPoint(x: 50, y: 50)
        imgProfile.layer.cornerRadius = 40
        imgProfile.clipsToBounds = true
        imgBG.addBlurEffect()
        //lblLogin.frame.origin  = CGPoint(x: 120, y: 20)
        //lblLogin.textAlignment = .left
        //lblLogin.bounds.size.width = screenW - 100
        
        //lblEmail.frame.origin  = CGPoint(x: 120, y: 60)
        //lblEmail.textAlignment = .left
        //lblEmail.bounds.size.width = screenW - 100
        //print ("***CEll - awakeFromNib")
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
