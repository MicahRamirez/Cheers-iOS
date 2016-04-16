//
//  CreateDrinkEventVC.swift
//  Cheers
//
//  Created by Xavier Ramirez on 4/3/16.
//  Copyright © 2016 cs378. All rights reserved.
//
import Alamofire
import UIKit

class CreateDrinkEventVC: UIViewController {
    
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
    //prepare for segue for add friends
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var pageVC = segue.destinationViewController as! PageVC
        pageVC.user = userDelegate
    }
    @IBAction func backButtonClicked(sender: UIButton) {
        self.performSegueWithIdentifier("unwindToPageVC", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func createDrinkEvent(sender: AnyObject) {
		
		// PARAMETERS FOR EVENT
		let theParameters = [
			"eventname": self.eventNameText!.text!,
			"organizer": "organizer",
			"location": self.locationText!.text!,
			"date": "date",
			"attendingList": [""],
			"invitedList": [""]
		]
		
		// POST DATA TO BACKEND
		Alamofire.request(.POST, "https://morning-crag-80115.herokuapp.com/user_create", parameters: theParameters as! [String : AnyObject], encoding: .JSON).responseJSON { response in
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

}
