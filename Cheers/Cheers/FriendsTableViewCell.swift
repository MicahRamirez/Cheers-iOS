//
//  FriendsTableViewCell.swift
//  Cheers
//
//  Created by Andy Tang on 3/23/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

//Base implementation of the Friendslist table view cell
class FriendsTableViewCell: UITableViewCell {
    
	@IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
