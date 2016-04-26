//
//  AcceptedEventVC.swift
//  Cheers
//
//  Created by Xavier Ramirez on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import QuartzCore

class AcceptedEventVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	// MARK: - Outlets & Variables
	
	@IBOutlet weak var acceptedEventHeader: UILabel!
	@IBOutlet weak var acceptedTableView: UITableView!
	
	var userDelegate:UserDelegateProtocol? = nil
    var colorConfig:UIColor?
    
	// MARK: - Override Methods
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Sets the table view
		self.acceptedTableView.delegate = self
		self.acceptedTableView.dataSource = self
		
		// Rounds the border
        self.acceptedEventHeader.layer.masksToBounds = true
        self.acceptedEventHeader.layer.cornerRadius = 12.0
		
		// Sets color
        if colorConfig != nil {
            self.view.backgroundColor = colorConfig
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	// MARK: - UITableView
	
	/// returns the number of sections
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	/// returns the number of rows
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1 //self.userDelegate!.acceptedEventListSize()
	}
	
	/// cellForRowAtIndexPath
	/// returns a configured custom cell
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("AcceptedEventCell", forIndexPath: indexPath) as! AcceptedEventCell
		
		// Assign all cell variables
		
		//let drinkEvent:DrinkEvent = userDelegate!.getAcceptedEvent(indexPath.row)

		//cell.organizerLabel.text! = drinkEvent.getOrganizer()
		//cell.locationLabel.text! = drinkEvent.getLocation()
		//cell.dateTimeLabel.text! = drinkEvent.getDateTime()
		
		return cell;
	}

}
