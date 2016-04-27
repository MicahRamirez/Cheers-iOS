//
//  AcceptedEventVC.swift
//  Cheers
//
//  Created by Xavier Ramirez on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire

class AcceptedEventVC: UIViewController, UITableViewDataSource, UITableViewDelegate, AECellDelegate {
    
    // MARK: - Outlets & Variables
    
    @IBOutlet weak var acceptedEventHeader: UILabel!
    @IBOutlet weak var acceptedTableView: UITableView!
    
    var userDelegate:UserDelegateProtocol? = nil
    var colorConfig:UIColor?
    var settingVar: SettingVars?
	
	let monthDict:[String:String] = [
		"01" : "Jan",
		"02" : "Feb",
		"03" : "Mar",
		"04" : "Apr",
		"05" : "May",
		"06" : "Jun",
		"07" : "Jul",
		"08" : "Aug",
		"09" : "Sep",
		"10" : "Oct",
		"11" : "Nov",
		"12" : "Dec"
	]
	let dayDict:[String:String] = [
		"1" : "Today",
		"2" : "Sun",
		"3" : "Mon",
		"4" : "Tue",
		"5" : "Wed",
		"6" : "Thu",
		"7" : "Fri",
		"8" : "Sat"
	]
	
    // MARK: - Override Methods
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Sets the table view
        self.acceptedTableView.delegate = self
        self.acceptedTableView.dataSource = self
		self.acceptedTableView!.backgroundColor! = UIColor(red: 205/255, green: 161/255, blue: 89/255, alpha: 1.0)
        
        // Rounds the border
        self.acceptedEventHeader.layer.masksToBounds = true
        self.acceptedEventHeader.layer.cornerRadius = 12.0
        
        // Sets the settings
        if self.settingVar != nil {
            if self.settingVar!.getColor() != nil {
                self.view.backgroundColor = self.settingVar!.getColor()
            }
        }
//        
//        // Sets color
//        if colorConfig != nil {
//            self.view.backgroundColor = colorConfig
//        }
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
        return self.userDelegate!.acceptedEventListSize()
    }
    
    /// cellForRowAtIndexPath
    /// returns a configured custom cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AcceptedEventCell", forIndexPath: indexPath) as! AcceptedEventCell
        
        // Assign all cell variables
        
        let drinkEvent:DrinkEvent = userDelegate!.getAcceptedEvent(indexPath.row)
        
        cell.organizerLabel.text! = drinkEvent.getOrganizer()
        cell.locationLabel.text! = drinkEvent.getLocation()
        cell.dateTimeLabel.text! = drinkEvent.getDateTime()
        
        return cell;
    }
    
    // MARK: - AECellDelegate
    
    /// cellTapped
    ///  delegate method that is called from the cell where the no button is pressed
    func cellTapped(cell: AcceptedEventCell) {
        let indexPath = self.acceptedTableView.indexPathForRowAtPoint(cell.center)!
        let drinkEvent:DrinkEvent = userDelegate!.getAcceptedEvent(indexPath.row)
        
        // Removes item
        
        // The item should be removed from the data model regardless
        self.userDelegate!.removeAcceptedEvent(indexPath.row)
        
        // Delete on the UI too
        self.acceptedTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        
    }
    
    ///callServerPendingEventAction
    /// POST Request to Server that deletes the pending item and if it is being accepted adds the DrinkEvent
    /// to the acceptedList
    func callServerPendingEventAction(parameters:[String:AnyObject]){
        Alamofire.request(.POST, "https://morning-crag-80115.herokuapp.com/update_pending_event/", parameters: parameters, encoding: .JSON)
        
    }
    
}
