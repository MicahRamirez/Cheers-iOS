//
//  PendingEventVC.swift
//  Cheers
//
//  Created by Xavier Ramirez on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire

class PendingEventVC: UIViewController, UITableViewDataSource, UITableViewDelegate, PECellDelegate {
	
	// MARK: - Outlets & Variables
	
	@IBOutlet weak var pendingDrinksHeader: UILabel!
	@IBOutlet weak var pendingDrinkTable: UITableView!
	
	var userDelegate:UserDelegateProtocol? = nil
    var colorConfig:UIColor?
    
	// MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Sets the pending drink table
        self.pendingDrinkTable.delegate = self
        self.pendingDrinkTable.dataSource = self
		
        // Rounds out the label header
        self.pendingDrinksHeader.layer.masksToBounds = true
        self.pendingDrinksHeader.layer.cornerRadius = 12.0
		
		// Sets background color
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
        return self.userDelegate!.pendingEventListSize()
    }
    
    /// cellForRowAtIndexPath
    /// returns a configured custom cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PendingEventCell", forIndexPath: indexPath) as! PendingEventCell
        
        //Assign all cell variables
        let drinkEvent:DrinkEvent = userDelegate!.getPendingEvent(indexPath.row)
        cell.delegate = self
        cell.organizer!.text! = drinkEvent.getOrganizer()
        cell.location!.text! = drinkEvent.getLocation()
        cell.dateTime!.text! = drinkEvent.getDateTime()
        
        return cell;
    }
	
	// MARK: - PECellDelegate
    
    /// cellTapped
    ///  delegate method that is called from the cell where the yes/no button is pressed
    func cellTapped(cell: PendingEventCell, accepted: Bool) {
        let indexPath = self.pendingDrinkTable.indexPathForRowAtPoint(cell.center)!
        let drinkEvent:DrinkEvent = userDelegate!.getPendingEvent(indexPath.row)
        
        /* Configure Params
        *  Required Body Params for updatePendingEventOnUser:
        *                   String:   req.body.username (Logged in User)
        *                   String:   req.body.eventName
        *                   String:   req.body.organizer
        *                   Boolean:  req.body.accepted
        */
        
        var parameters:[String:AnyObject] = [
                "username":     self.userDelegate!.getUsername(),
                "eventName":    drinkEvent.getEventName(),
                "organizer":    drinkEvent.getOrganizer(),
                "accepted":     accepted
        ]
        //call server
        self.callServerPendingEventAction(parameters)
        
        //the item should be removed from the data model regardless
        self.userDelegate!.removePendingEvent(indexPath.row)
        //delete on the UI too
        self.pendingDrinkTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        if accepted {
            //add to the accepted list
            self.userDelegate!.addAcceptedEvent(drinkEvent)
        }
    }
    
    ///callServerPendingEventAction
    /// POST Request to Server that deletes the pending item and if it is being accepted adds the DrinkEvent
    /// to the acceptedList
    func callServerPendingEventAction(parameters:[String:AnyObject]){
        Alamofire.request(.POST, "https://morning-crag-80115.herokuapp.com/update_pending_event/", parameters: parameters, encoding: .JSON)
        
    }
}
