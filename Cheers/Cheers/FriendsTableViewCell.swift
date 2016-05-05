//
//  FriendsTableViewCell.swift
//  Cheers
//
//  Created by Andy Tang on 3/23/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
	
	// MARK: - Outlets & Variables
    
	@IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusIcon: UIImageView!
    @IBOutlet weak var spaceLbl: UILabel!
	
	// MARK: - Override Functions
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
