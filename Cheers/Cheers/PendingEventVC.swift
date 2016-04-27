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
        //first elem is month, second is day, third is AM/PM Time, day of week
        let formattedDate:[String] = self.formatDate(drinkEvent.getDateTime())
        print(formattedDate)
        cell.delegate = self
        cell.eventName!.text! = drinkEvent.getEventName()
        cell.organizer!.text! = drinkEvent.getOrganizer()
        cell.location!.text! = drinkEvent.getLocation()
        cell.day!.text! = formattedDate[1]
        cell.dayOfWeek!.text! = formattedDate[3]
        cell.time!.text! = formattedDate[2]
        print("This is date Time")
        print(drinkEvent.getDateTime())
        
        return cell;
    }
    
    ///formatDate
    /// formats the ugly date string that starts off as 2016-04-26 03:08:09 +0000
    func formatDate(dateString:String) -> [String]{
        //result array
        var dateStringArr:[String] = [String]()
        //breaking into 2XXX-XX-XX, XX:XX:XX, +XXXX
        let fullDateComponents:[String] = dateString.characters.split{$0 == " "}.map(String.init)
        //breaking date component into YYYY, MM, DD
        let dateComponents:[String] = fullDateComponents[0].characters.split{$0 == "-"}.map(String.init)
        dateStringArr.append(dateComponents[1])
        dateStringArr.append(dateComponents[2])
        //breaking time component into HH, MM, SS
        let timeComponents:[String] = fullDateComponents[1].characters.split{$0 == ":"}.map(String.init)
        let timeString:String = timeComponents[0] + ":" + timeComponents[1]
        if Int(timeComponents[0]) < 12{
            dateStringArr.append(timeString + " AM")
        }else{
            dateStringArr.append(timeString + " PM")
        }
        
        if let weekday = self.getDayOfWeek("2014-08-27") {
            dateStringArr.append(self.dayDict[String(weekday)]!)
            print(weekday)
        } else {
            print("bad input")
        }
        
        
        return dateStringArr
    }
    
    ///getDayOfWeek
    /// used code from the following SO post
    /// http://stackoverflow.com/questions/25533147/get-day-of-week-using-nsdate-swift
    func getDayOfWeek(today:String)->Int? {
        
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = formatter.dateFromString(today) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
            let weekDay = myComponents.weekday
            return weekDay
        } else {
            return nil
        }
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
