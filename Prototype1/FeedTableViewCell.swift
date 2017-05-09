//
//  FeedTableViewCell.swift
//  RSSReader
//
//  Created by Alex iMac on 04.05.17.
//  Copyright © 2017 Alex iMac. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var itemTitleLbl: UILabel!
    @IBOutlet weak var itemAuthorLbl: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    

}
