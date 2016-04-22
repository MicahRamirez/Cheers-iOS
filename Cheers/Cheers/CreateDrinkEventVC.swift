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
	
    @IBOutlet weak var friends: UITableView!
	
    var userDelegate:UserDelegateProtocol?
	var alertController:UIAlertController? = nil
    var colorConfig:UIColor?
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("GOTTHOIIIHS")
        self.friends.delegate = self
        self.friends.dataSource = self
        if colorConfig != nil {
            self.view.backgroundColor = self.colorConfig
        }
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
		
        self.userDelegate!.getFriendsList()
		// PARAMETERS FOR EVENT
        let theParameters:[String:AnyObject] = [
			"eventname": self.eventNameText!.text!,
			"organizer": self.userDelegate!.getUsername(),
			"location": self.locationText!.text!,
			"date": self.datePicker.date.description,
			"attendingList": [self.userDelegate!.getUsername()],
			"invitedList": Array(self.userDelegate!.getFriendsList().keys)
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
		
		// Adds Event under current user's account as acceptedEvents
//		self.userDelegate!.addEvent(theParameters)
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
        pageVC.colorConfig = self.colorConfig
	}
}
