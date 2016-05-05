//
//  FriendTableCell.swift
//  Cheers
//
//  Created by Xavier Ramirez on 4/12/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class FriendTableCell: UITableViewCell {
	
	// MARK: - Outlets & Variables

    @IBOutlet weak var friendLbl: UILabel!
    @IBOutlet weak var checkedBtn: UIButton!
    @IBOutlet weak var spaceLbl: UILabel!
    var count:Int = 0;
	
	// MARK: - Override Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
