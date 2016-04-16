//
//  CreateDrinkEventVC.swift
//  Cheers
//
//  Created by Xavier Ramirez on 4/3/16.
//  Copyright © 2016 cs378. All rights reserved.
//
import Alamofire
import UIKit

class CreateDrinkEventVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets & Class Instance
    
    @IBOutlet weak var eventNameText: UITextField!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var timeText: UITextField!
    @IBOutlet weak var friendsList: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
	
	
    var userDelegate:UserDelegateProtocol?
	var alertController:UIAlertController? = nil
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
	
	@IBAction func backButtonClicked(sender: UIButton) {
		self.performSegueWithIdentifier("unwindToPageVC", sender: self)
	}
	
    @IBAction func createDrinkEvent(sender: AnyObject) {
		
		// PARAMETERS FOR EVENT
		let theParameters = [
			"eventname": self.eventNameText!.text!,
			"organizer": "Organizer",
			"location": self.locationText!.text!,
			"date": self.datePicker.date.description,
			"attendingList": [""],
			"invitedList": [""]
		]
		
		// POST DATA TO BACKEND
		Alamofire.request(.POST, "https://morning-crag-80115.herokuapp.com/add_drink_event/", parameters: (theParameters as! [String : AnyObject]), encoding: .JSON).responseJSON { response in
			if let JSON = response.result.value {
				print(JSON)
			}
		}

		// ALERT CONTROL
		self.alertController = UIAlertController(title: "Event Added!", message: "Event has been successfully added!", preferredStyle: UIAlertControllerStyle.Alert)
		
		let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
		}
		self.alertController!.addAction(okAction)
		self.presentViewController(self.alertController!, animated: true, completion:nil)
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
		let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! FriendsTableViewCell
		let list = Array(self.userDelegate!.getFriendsList().keys)
		let friend = list[indexPath.row]
		cell.nameLabel.text = friend
		
		return cell
	}
	
	// MARK: - Navigation
	
	//prepare for segue for add friends
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let pageVC = segue.destinationViewController as! PageVC
		pageVC.user = userDelegate
	}

}
