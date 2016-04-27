//
//  AcceptedEventCell.swift
//  Cheers
//
//  Created by Andy Tang on 4/25/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class AcceptedEventCell: UITableViewCell {

    // MARK: - Outlets & Variables

	@IBOutlet weak var dayOfWeekLabel: UILabel!
	@IBOutlet weak var dayLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var organizerLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var month: UILabel!
    
    var delegate:AECellDelegate? = nil
    
    // MARK: - Actions
    
    /// Deletes event from Accepted Drink Events Table
    /// and event user's acceptedEventList.
    /// delegates the serverside/client side to call to update Accepted Events Function
	@IBAction func cancelBtn(sender: AnyObject) {
		self.delegate?.cellTapped(self)
	}
}
