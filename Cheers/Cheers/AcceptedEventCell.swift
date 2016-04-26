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
    
    var delegate:AECellDelegate? = nil
    
    // MARK: - Actions
    
    /// Deletes event from Accepted Drink Events Table
    /// and event user's acceptedEventList.
    /// delegates the serverside/client side to call to update Accepted Events Function
    @IBAction func Nobtn(sender: AnyObject) {
        self.delegate?.cellTapped(self)
    }
}
