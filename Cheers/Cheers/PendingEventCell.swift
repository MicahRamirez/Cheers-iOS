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
    var delegate:PECellDelegate? = nil
    
    ///eventApproved
    /// delegates the serverside/client side call to updatePendingEvents function
    @IBAction func eventApproved(sender: AnyObject) {
        var eventOrigin:UIButton = sender as! UIButton
        self.delegate?.cellTapped(self, accepted:true)
    }
    
    ///eventRejected
    /// delegates the serverside/client side call to updatePendingEvents function
    @IBAction func eventRejected(sender: AnyObject) {
        print(sender)
        self.delegate?.cellTapped(self, accepted:false)
    }
    
    func updatePendingEvents(accepted:Bool) {
        //do stuff 
        
        //update appside
        //either use a delegate/visitor to change datamodel or use a function to update local model
    }
    
    func callServer() {
        /*
        * updatePendingEventOnUser
        *  updates the pending event on a SINGLE user based on params pased in req.body
        *  HTTP POST
        *  Required Body Params :
        *                   String:   req.body.username (Logged in User)
        *                   String:   req.body.eventName
        *                   String:   req.body.organizer
        *                   Boolean:  req.body.accepted 
        */
    }
}
