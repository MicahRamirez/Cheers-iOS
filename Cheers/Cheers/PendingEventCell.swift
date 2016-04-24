//
//  PendingEventCell.swift
//  Cheers
//
//  Created by Xavier Ramirez on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class PendingEventCell: UITableViewCell {
    @IBOutlet weak var organizer: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    
    ///eventApproved
    /// delegates the serverside/client side call to updatePendingEvents function
    @IBAction func eventApproved(sender: AnyObject) {
        self.updatePendingEvents(true)
    }
    
    ///eventRejected
    /// delegates the serverside/client side call to updatePendingEvents function
    @IBAction func eventRejected(sender: AnyObject) {
        self.updatePendingEvents(false)
    }
    
    func updatePendingEvents(accepted:Bool) {
        //do stuff 
        
        //update appside
        //either use a delegate/visitor to change datamodel or use a function to update local model
    }
}
