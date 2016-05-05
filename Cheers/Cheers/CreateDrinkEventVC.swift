//
//  CreateDrinkEventVC.swift
//  Cheers
//
//  Created by Xavier Ramirez on 4/3/16.
//  Copyright © 2016 cs378. All rights reserved.
//
import Alamofire
import UIKit

class CreateDrinkEventVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    // MARK: - Outlets & Variables
    
    @IBOutlet weak var eventNameText: UITextField!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var timeText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var friends: UITableView!
    var userDelegate:UserDelegateProtocol?
	var alertController:UIAlertController? = nil
    var colorConfig:UIColor?
    var autoDrink:Bool?
    var fromTime:UIDatePicker?
    var toTime:UIDatePicker?
    var settingVar: SettingVars?
    let monthDict:[String:String] = [
        "January" : "01",
        "February" : "02",
        "March" : "03",
        "April" : "04",
        "May" : "05",
        "June" : "06",
        "July" : "07",
        "August" : "08",
        "September" : "09",
        "October" : "10",
        "November" : "11",
        "December" : "12"
    ]
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
		super.viewDidLoad()
        
        self.eventNameText.delegate = self
        self.locationText.delegate = self
        
        self.friends!.backgroundColor! = UIColor(red: 205/255, green: 161/255, blue: 89/255, alpha: 1.0)
    
        // Cuts extra footer
        friends.tableFooterView = UIView()
        
        self.datePicker.timeZone? = NSTimeZone.localTimeZone()

        self.friends.delegate = self
        self.friends.dataSource = self
        
        if self.settingVar != nil {
            if self.settingVar!.getColor() != nil {
                self.view.backgroundColor = self.settingVar!.getColor()
                self.friends!.backgroundColor = self.settingVar!.getColor()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
	
	@IBAction func backButtonClicked(sender: UIButton) {
		self.performSegueWithIdentifier("unwindToPageVC", sender: self)
	}
	
	@IBAction func createDrinkEvent(sender: AnyObject) {
		
		self.userDelegate!.getFriendsList()
		var localDateString:String = self.createLocalTimeString(self.datePicker.date.descriptionWithLocale(NSLocale.currentLocale()))
		// PARAMETERS FOR EVENT
		let theParameters:[String:AnyObject] = [
			"eventName": self.eventNameText!.text!,
			"organizer": self.userDelegate!.getUsername(),
			"location": self.locationText!.text!,
			"date": localDateString,
			"attendingList": [self.userDelegate!.getUsername()],
			"invitedList": Array(self.userDelegate!.getFriendsList().keys)
		]
		
		// POST DATA TO BACKEND
		Alamofire.request(.POST, "https://morning-crag-80115.herokuapp.com/add_drink_event/", parameters: theParameters, encoding: .JSON).responseJSON { response in
			if let JSON = response.result.value {
				// Adds Event under current user's account as acceptedEvents
				// !!!! CAREFUL !!!!!
				// Casting [AnyObjects] to [SomeType] could cause exception. TEST DIS
				//locale date string is in the form YYYY-MM-DD HH:MM:SS +0000
				let newDrinkEvent:DrinkEvent = DrinkEvent(organizer: theParameters["organizer"] as! String, eventName: theParameters["eventName"] as! String, location: theParameters["location"] as! String, date: localDateString, invitedList: theParameters["invitedList"] as! [String], attendedList: theParameters["attendingList"] as! [String])
				self.userDelegate!.addAcceptedEvent(newDrinkEvent)
			}
		}
		
		// ALERT CONTROL
		self.alertController = UIAlertController(title: "Event Added!", message: "Event has been successfully added!", preferredStyle: UIAlertControllerStyle.Alert)
		
		let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
		}
		self.alertController!.addAction(okAction)
		self.presentViewController(self.alertController!, animated: true, completion:nil)
	}
	
	// MARK: - Helper Methods
	
    func createLocalTimeString(verboseDate:String) -> String {
        //verboseDate String looks like "Wednesday, April 27, 2016 at 4:00:21 PM"
        var formatedString:String = ""
        
        //split by spaces
        //0: Wednesday,  1:April 2: 27, 3:2016 4:at 5: 4:00:21 6:PM
        var splitString:[String] = verboseDate.characters.split{$0 == " "}.map(String.init)
        formatedString.appendContentsOf(splitString[3])
        formatedString.appendContentsOf("-")
        formatedString.appendContentsOf(self.monthDict[splitString[1]]!)
        var tmpDay:String = splitString[2].stringByReplacingOccurrencesOfString(",", withString: "")
        formatedString.appendContentsOf("-")
        formatedString.appendContentsOf(tmpDay)
        formatedString.appendContentsOf(" ")
        var tmpTime:[String] = splitString[5].characters.split{$0 == ":"}.map(String.init)
        var tmpHour:Int = 0
        if splitString[6] == "PM" {
            //add 12 to the first item of the first split
            tmpHour = Int(tmpTime[0])! + 12
            tmpTime[0] = String(tmpHour)
        } else {
            if tmpTime[0].characters.count == 1{
                tmpTime[0] = "0" + tmpTime[0]
            }
        }
        formatedString.appendContentsOf(tmpTime.joinWithSeparator(":"))
        formatedString.appendContentsOf(" ")
        formatedString.appendContentsOf("+0000")
        return formatedString
    }
    
    // MARK: - UITableView
    
    // numberOfSectionsInTableView - returns the number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // numberOfRowsInSection - returns the number of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userDelegate!.getFriendsList().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CreateDrinkFriends", forIndexPath: indexPath) as! FriendTableCell
        let list = Array(self.userDelegate!.getFriendsList().keys)
        let friend = list[indexPath.row]
        cell.friendLbl.text! = friend
		
        if self.settingVar != nil {
            if self.settingVar!.getColor() != nil {
                cell.spaceLbl!.backgroundColor = self.settingVar!.getColor()
            }
        }
        		
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FriendTableCell
        
        let imageOn = UIImage(named: "Dark-Blue-Button-filled-01.png")
        let imageOff = UIImage(named: "Dark-Blue-Button-01.png")
		
        if cell.count % 2 == 0 {
            cell.checkedBtn.setImage(imageOn, forState: .Normal)
        }
        else if cell.count % 2 == 1 {
            cell.checkedBtn.setImage(imageOff, forState: .Normal)
        }
		
        cell.count = cell.count + 1
        tableView.reloadData()
    }

	// MARK: - Navigation
	
	//prepare for segue for add friends
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let pageVC = segue.destinationViewController as! PageVC
		pageVC.user = userDelegate
        pageVC.settingVar = self.settingVar
	}
	
	// MARK: - UITextFieldDelegate
    
    // UITextFieldDelegate delegate method
    //
    // This method is called when the user touches the Return key on the
    // keyboard. The 'textField' passed in is a pointer to the textField
    // widget the cursor was in at the time they touched the Return key on
    // the keyboard.
    //
    // From the Apple documentation: Asks the delegate if the text field
    // should process the pressing of the return button.
    //
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // A responder is an object that can respond to events and handle them.
        //
        // Resigning first responder here means this text field will no longer be the first
        // UI element to receive an event from this apps UI - you can think of it as giving
        // up input 'focus'.
        self.eventNameText.resignFirstResponder()
        self.locationText.resignFirstResponder()
        
        return true
    }
    
    // Called when the user touches on the main view (outside the UITextField).
    // This causes the keyboard to go away also - but handles all situations when
    // the user touches anywhere outside the keyboard.
    //
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
