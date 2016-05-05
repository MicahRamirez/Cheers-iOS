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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.acceptedTableView!.reloadData()
        dispatch_async(dispatch_get_main_queue(), {
            //This code will run in the main thread:
            var frame:CGRect = self.acceptedTableView.frame;
            frame.size.height = self.acceptedTableView.contentSize.height;
            self.acceptedTableView.frame = frame;
        });
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	// MARK: - Helper Functions
	
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
		cell.delegate = self
		
		// Sets the Event Name/Organizer/Location
        let drinkEvent:DrinkEvent = userDelegate!.getAcceptedEvent(indexPath.row)
		cell.eventNameLabel.text! = drinkEvent.getEventName()
        cell.organizerLabel.text! = drinkEvent.getOrganizer()
        cell.locationLabel.text! = drinkEvent.getLocation()
		
		// Sets the Date
		// first elem is month, second is day, third is AM/PM Time, day of week
		let formattedDate:[String] = self.formatDate(drinkEvent.getDateTime())
		cell.dayLabel.text! = formattedDate[1]
		cell.dayOfWeekLabel.text! = formattedDate[3]
		cell.timeLabel.text! = formattedDate[2]
        cell.month.text! = self.monthDict[formattedDate[0]]!
		
        return cell;
    }
    
    // MARK: - AECellDelegate
    
    /// cellTapped
    ///  delegate method that is called from the cell where the no button is pressed
    func cellTapped(cell: AcceptedEventCell) {
        let indexPath = self.acceptedTableView.indexPathForRowAtPoint(cell.center)!
        let drinkEvent:DrinkEvent = userDelegate!.getAcceptedEvent(indexPath.row)
		
        // The item should be removed from the data model regardless
        self.userDelegate!.removeAcceptedEvent(indexPath.row)
        
        // Delete on the UI too
        self.acceptedTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        
    }
    
    ///callServerAcceptedEventAction
    /// POST Request to Server that deletes the pending item and if it is being accepted adds the DrinkEvent
    /// to the acceptedList
    func callServerAcceptedEventAction(parameters:[String:AnyObject]){
        Alamofire.request(.POST, "https://morning-crag-80115.herokuapp.com/update_pending_event/", parameters: parameters, encoding: .JSON)
        
    }
}
