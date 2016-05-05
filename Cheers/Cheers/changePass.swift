//
//  changePass.swift
//  Cheers
//
//  Created by Cheng yuan Ma on 5/4/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Alamofire

class changePass: UIViewController, UITextFieldDelegate {
	
	// MARK: - Outlets & Variables

	@IBOutlet weak var currentPass: UITextField!
	@IBOutlet weak var newPass: UITextField!
    var settingVar:SettingVars?
    var user:UserDelegateProtocol?
    var alertController:UIAlertController? = nil
    var alertController1:UIAlertController? = nil
	
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentPass.delegate = self
        self.newPass.delegate = self
        if self.settingVar != nil {
            if self.settingVar!.getColor() != nil {
                self.view.backgroundColor = self.settingVar!.getColor()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	// MARK: - Actions
    
    @IBAction func backBtn(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
	
    @IBAction func submitBtn(sender: AnyObject) {
        
        Alamofire.request(.GET, "https://morning-crag-80115.herokuapp.com/login/\(self.user!.getUsername())/\(self.currentPass!.text!)")
            .responseJSON { response in
                if let JSON = response.result.value {
                    
                    let parameters:[String:AnyObject] = [
                        "username": self.user!.getUsername(),
                        "newpassword" : self.newPass!.text!,
                    ]
                    // post to backend to register the user
                    Alamofire.request(.POST, "https://morning-crag-80115.herokuapp.com/change_password", parameters: parameters, encoding: .JSON)
                    
                    self.alertController1 = UIAlertController(title: "Password Change", message: "Password has been updated!", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
                    
                        let settingPage = self.storyboard?.instantiateViewControllerWithIdentifier("settings") as! settingsVC
                        settingPage.user = self.user
                        settingPage.settingVar = self.settingVar
                        self.presentViewController(settingPage, animated: true, completion: nil)
                    
                    }
                    self.alertController1!.addAction(okAction)
                    self.presentViewController(self.alertController1!, animated: true, completion:nil)
                }
                
                else {
                    
                    self.alertController = UIAlertController(title: "Authentication", message: "Current Password is incorrect", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in}
                    self.alertController!.addAction(okAction)
                    self.presentViewController(self.alertController!, animated: true, completion:nil)
                    
                }
        }
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
        self.currentPass.resignFirstResponder()
        self.newPass.resignFirstResponder()
        
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
