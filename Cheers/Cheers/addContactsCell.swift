//
//  addContactsCell.swift
//  Cheers
//
//  Created by Cheng yuan Ma on 4/21/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class addContactsCell: UITableViewCell {
    
    var count = 0
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var spaceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
