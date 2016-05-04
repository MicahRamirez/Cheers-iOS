//
//  addFriends.swift
//  Cheers
//
//  Created by Cheng yuan Ma on 3/29/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Alamofire

class addFriends: UIViewController, UITextFieldDelegate {
	
	// MARK: - Outlets
	
    @IBOutlet weak var friendTxt: UITextField!
	
	// MARK: - Class Instances
	
    var alertController:UIAlertController? = nil
    var user:UserDelegateProtocol?
    var colorConfig:UIColor?
    var autoDrink:Bool?
    var fromTime:UIDatePicker?
    var toTime:UIDatePicker?
    var settingVar: SettingVars?
	
	// MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.friendTxt.delegate = self
        if self.settingVar != nil {
            if self.settingVar!.getColor() != nil {
                self.view.backgroundColor = self.settingVar!.getColor()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
    
    @IBAction func addbtn(sender: AnyObject) {
		
        friendTxt.text = friendTxt.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        var userExists:Bool = false
		
        //exists ? then add to friends list
        Alamofire.request(.GET, "https://morning-crag-80115.herokuapp.com/cheers_user/exists/\(self.friendTxt!.text!)").responseJSON {
			response in
			//result is response of serialization
			userExists = response.result.value!["exists"] as! Bool
			self.addFriend(userExists)
        }
    }
    
    func addFriend(userExists:Bool) {
		if userExists && self.friendTxt!.text! != self.user?.getUsername() {

			let theParameters = [ "username": self.user!.getUsername(), //logged in user
				"friend" : self.friendTxt!.text! //user to be added that we know already exists!
			]
			
            print(theParameters["username"])
            print(theParameters["friend"])
            
            //post to backend to register the user
            Alamofire.request(.POST, "https://morning-crag-80115.herokuapp.com/add_friend/", parameters: theParameters, encoding: .JSON).responseJSON { response in
            }
            //THIS FRIEND HASN"T EVEN BEEN ADDED HOW WOULD IT BE IN THE FRIENDS LIST?????
            //Assumme it to be false initially
            user!.addFriend(self.friendTxt!.text!, status: false)

            self.alertController = UIAlertController(title: "Friend Added!", message: "\(self.friendTxt!.text!) has been successfully added!", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
                let main = self.storyboard?.instantiateViewControllerWithIdentifier("PageVC") as! PageVC
                self.user!.addFriend(self.friendTxt!.text!, status:false)
                main.user = self.user
                main.settingVar = self.settingVar
                self.presentViewController(main, animated: true, completion: nil)
            }
            
            self.alertController!.addAction(okAction)
            self.presentViewController(self.alertController!, animated: true, completion:nil)
        }
		else {
            self.alertController = UIAlertController(title: "Error!", message: "Friend was not found/ You cannot add yourself to friends list", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
            }
            self.alertController!.addAction(okAction)
            self.presentViewController(self.alertController!, animated: true, completion:nil)
        }
        
    }
	
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier! == "backToMain") {
            let page = segue.destinationViewController as! PageVC
            page.user = self.user
            page.settingVar = self.settingVar
        }
    }
    
    
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
        self.friendTxt.resignFirstResponder()
        
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
