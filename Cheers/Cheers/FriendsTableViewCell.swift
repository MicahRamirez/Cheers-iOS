//
//  FriendsTableViewCell.swift
//  Cheers
//
//  Created by Andy Tang on 3/23/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
	
	// MARK: - Outlets

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var statusIcon: UIImageView!

	// MARK: - Functions
	
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
