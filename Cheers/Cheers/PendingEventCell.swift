//
//  PendingEventCell.swift
//  Cheers
//
//  Created by Xavier Ramirez on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class PendingEventCell: UITableViewCell {
    var delegate:PECellDelegate? = nil
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var organizer: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var dayOfWeek: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var time: UILabel!
    
    
    ///eventApproved
    /// delegates the serverside/client side call to updatePendingEvents function
    @IBAction func eventApproved(sender: AnyObject) {
        self.delegate?.cellTapped(self, accepted:true)
    }
    
    ///eventRejected
    /// delegates the serverside/client side call to updatePendingEvents function
    @IBAction func eventRejected(sender: AnyObject) {
        self.delegate?.cellTapped(self, accepted:false)
    }
}
