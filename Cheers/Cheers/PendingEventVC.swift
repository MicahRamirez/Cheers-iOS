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
	var settingVar: SettingVars?
    var timer:NSTimer? = nil
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

		// Sets the pending drink table
        self.pendingDrinkTable.delegate = self
        self.pendingDrinkTable.dataSource = self
		self.pendingDrinkTable!.backgroundColor! = UIColor(red: 205/255, green: 161/255, blue: 89/255, alpha: 1.0)
		
        // Rounds out the label header
        self.pendingDrinksHeader.layer.masksToBounds = true
        self.pendingDrinksHeader.layer.cornerRadius = 12.0
		
        
        if self.settingVar != nil {
            if self.settingVar!.getColor() != nil {
                self.view.backgroundColor = self.settingVar!.getColor()
            }
        }
    }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "pollFunc", userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer?.invalidate()
    }
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		dispatch_async(dispatch_get_main_queue(), {
			//This code will run in the main thread:
			var frame:CGRect = self.pendingDrinkTable.frame;
			frame.size.height = self.pendingDrinkTable.contentSize.height;
			self.pendingDrinkTable.frame = frame;
		});
	}
	
	// MARK: - Helper Methods
    
    func pollFunc(){
        Alamofire.request(.GET, "https://morning-crag-80115.herokuapp.com/query_pending_events/\(self.userDelegate!.getUsername())").responseJSON { response in
                if let JSON = response.result.value {
                    var toCheck:[DrinkEvent] = self.convertJsonToEvent(JSON["pendingEvents"] as! [AnyObject])
                    var needUpdate:Bool = self.userDelegate!.eventAlreadyInPending(toCheck)
                    if needUpdate {
                        self.pendingDrinkTable!.reloadData()
                        self.viewWillLayoutSubviews()
                    }
                }
            }
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
        var hourVal:Int = Int(timeComponents[0])!
        if hourVal > 12 {
            hourVal = hourVal - 12
        }
        var hourString:String = String(hourVal)
		let timeString:String = hourString + ":" + timeComponents[1]
		if Int(timeComponents[0]) < 12{
			dateStringArr.append(timeString + " AM")
		}else{
			dateStringArr.append(timeString + " PM")
		}
		
		if let weekday = self.getDayOfWeek("2014-08-27") {
			dateStringArr.append(self.dayDict[String(weekday)]!)
		} else {
            
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
	
	/// convertJsonToEvent
	///     utility function to convert List of AnyObjects which represent DrinkEvents into actual DrinkEvents
	///     returns the converted DrinkEvent Array
	func convertJsonToEvent(toConvert:[AnyObject]) -> [DrinkEvent]{
		var converted:[DrinkEvent] = [DrinkEvent]()
		//iterate through the potential event objects from the json
		for event in toConvert{
			//cast to dict like object so we can access vals
			let eventAttributes:[String:AnyObject] = event as! [String:AnyObject]
			//open up the object and start building the new Event Obj and Cast as seen fit
			let organizer:String = eventAttributes["organizer"] as! String
			let eventName:String = eventAttributes["eventName"] as! String
			let location:String = eventAttributes["location"] as! String
			let date:String = eventAttributes["date"] as! String
			let attendingList:[String] = eventAttributes["attendingList"] as! [String]
			let invitedList:[String] = eventAttributes["invitedList"] as! [String]
			converted.append(DrinkEvent(organizer: organizer, eventName: eventName, location: location, date: date, invitedList: invitedList, attendedList: attendingList))
		}
		
		return converted
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
        
        //sepecify cell attributes
        cell.delegate = self
        cell.eventName!.text! = drinkEvent.getEventName()
        cell.organizer!.text! = drinkEvent.getOrganizer()
        cell.location!.text! = drinkEvent.getLocation()
        cell.day!.text! = formattedDate[1]
        cell.dayOfWeek!.text! = formattedDate[3]
        cell.time!.text! = formattedDate[2]
        cell.month!.text! = self.monthDict[formattedDate[0]]!
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
        
        let parameters:[String:AnyObject] = [
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
