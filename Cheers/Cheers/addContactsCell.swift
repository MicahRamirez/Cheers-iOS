//
//  addContactsCell.swift
//  Cheers
//
//  Created by Cheng yuan Ma on 4/21/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class addContactsCell: UITableViewCell {
	
	// MARK: - Outlets & Variables

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var spaceLbl: UILabel!
	var count = 0
	
	// MARK: - Override Functions
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
