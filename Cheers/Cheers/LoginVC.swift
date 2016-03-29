//
//  LoginVC.swift
//  Cheers
//
//  Created by Xavier Ramirez on 3/16/16.
//  Sample code used from cs378 iOS for resigning keyboard made by Bob Seitsinger
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Alamofire

class LoginVC: UIViewController, UITextFieldDelegate {
    
    var alertController:UIAlertController?=nil
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var cheersLogo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // You have to identify this object (self) as the one that will receive delegate calls
        // (think old-fashioned callbacks) from the framework code that handles UITextField
        // events. If you don't, the framework's call to textFieldShouldReturn (below) won't
        // get here, and the keyboard won't go away using this mechanism.
        self.username.delegate = self
        self.password.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func authenticateUser(sender: AnyObject) {
        
        // Verifies for extra spaces by coercing (trimming) white spaces from front and end
        username.text = username.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        password.text = password.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        Alamofire.request(.GET, "https://morning-crag-80115.herokuapp.com/login/\(self.username!.text!)/\(self.password!.text!)")
            .responseJSON { response in
                //request is original URL request
                //response is URL response
                //data is server data/payload
                //result is response of serialization
                if let JSON = response.result.value {
                    //Use CORE Data to instantiate this user object if it doesn't already exist?
                    let main = self.storyboard?.instantiateViewControllerWithIdentifier("PageVC") as! PageVC
                    main.loggedInUserName = self.username!.text!
                    self.presentViewController(main, animated: true, completion: nil)
                }else{
                    
                    self.alertController = UIAlertController(title: "Failed Authentication", message: "Invalid Username or Password", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
                    }
                    
                    
                    self.alertController!.addAction(okAction)
                    self.presentViewController(self.alertController!, animated: true, completion:nil)
                    
                }
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
        self.username.resignFirstResponder()
        self.password.resignFirstResponder()
        
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
