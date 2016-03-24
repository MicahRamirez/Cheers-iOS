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
    
    @IBAction func eventApproved(sender: AnyObject) {
    }
    @IBAction func eventRejected(sender: AnyObject) {
    }
}
