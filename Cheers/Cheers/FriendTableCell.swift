//
//  FriendTableCell.swift
//  Cheers
//
//  Created by Xavier Ramirez on 4/12/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class FriendTableCell: UITableViewCell {

    @IBOutlet weak var friendLbl: UILabel!
    @IBOutlet weak var checkedBtn: UIButton!
    
    var count:Int = 0;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
