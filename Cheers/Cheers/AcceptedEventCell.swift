//
//  AcceptedEventCell.swift
//  Cheers
//
//  Created by Andy Tang on 4/25/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class AcceptedEventCell: UITableViewCell {
	
	// MARK: - Outlets
	
	@IBOutlet weak var organizerLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var dateTimeLabel: UILabel!
	
	// MARK: - Actions
	
	// Deletes event from Accepted Drink Events Table
	// and event user's acceptedEventList.
	@IBAction func Nobtn(sender: AnyObject) {
		
	}
}
