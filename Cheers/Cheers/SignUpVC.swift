//
//  SignUpVC.swift
//  Cheers
//
//  Created by Xavier Ramirez on 3/16/16.
//  Sample code used from cs378 iOS for resigning keyboard made by Bob Seitsinger
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Alamofire

class SignUpVC: UIViewController, UITextFieldDelegate {
	
	// MARK: - Outlets & Variables
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    var textFieldArr:[UITextField]? = nil
    var alertController:UIAlertController? = nil
	
	// MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldArr = [self.email, self.password, self.userName, self.lastName, self.firstName]
        self.email.delegate = self
        self.password.delegate = self
        self.userName.delegate = self
        self.lastName.delegate = self
        self.firstName.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	// MARK: - Actions
    
    ///verifySignUp
    /// verifies the input in text fields and if valid creates a user in CORE
    /// this data should also be sent to the MongoDB via POST
    /// user should be logged in if info is valid
    @IBAction func verifySignUp(sender: AnyObject) {
        
        Alamofire.request(.GET, "https://morning-crag-80115.herokuapp.com/cheers_user/exists/\(self.userName!.text!)")
            .responseJSON { response in
                //request is original URL request
                //response is URL response
                //data is server data/payload
                //result is response of serialization
                let userExists = response.result.value!["exists"] as! Bool
                
                if userExists == false {
                    let res = self.textFieldArr!.filter {$0.text! == ""}
                    //if all fields have been entered with text
                    if res.count == 0 {
                        
                        // for now not encrypting passwords RIP
                        // these parameters are what is defined in the schema in the
                        // nodeJS/Express server. DO NOT CHANGE UNLESS YOU KNOW WHAT YOU
                        // ARE DOING
                        let parameters:[String:AnyObject] = [
                            "firstName": self.firstName!.text!,
                            "lastName" : self.lastName!.text!,
                            "username" : self.userName!.text!,
                            "password" : self.password!.text!,
                            "email" : self.email!.text!,
                            "status" : false
                        ]
                        // post to backend to register the user
                        Alamofire.request(.POST, "https://morning-crag-80115.herokuapp.com/user_create", parameters: parameters, encoding: .JSON)
                        
                        //Create User
                        let person = User(firstName: self.firstName!.text!, lastName: self.lastName!.text!, username: self.userName!.text!, status: false, friendsList: [String:Bool](), pendingEventList: [], acceptedEventList: [], password: self.password!.text!)
                        // Go to main screen
                        let pageVC = self.storyboard?.instantiateViewControllerWithIdentifier("PageVC") as! PageVC
                        pageVC.user = person
                        self.presentViewController(pageVC, animated: true, completion: nil)
                    }
                    
                }
                else {
                    //user already exists with same username
                    self.alertController = UIAlertController(title: "Invalid username", message: "Username already exists. Please type in another username.", preferredStyle: UIAlertControllerStyle.Alert)
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
        self.email.resignFirstResponder()
        self.password.resignFirstResponder()
        self.userName.resignFirstResponder()
        self.lastName.resignFirstResponder()
        self.firstName.resignFirstResponder()
        
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
