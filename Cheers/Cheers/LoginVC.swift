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
    var parameters:[String: AnyObject] = [String:AnyObject]()
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var cheersLogo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
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
                var friendsNames:[String]? = nil
                if let JSON = response.result.value {
                    if let nsFriendsList:NSArray =  JSON["friendsList"] as? NSArray{
                        let friendsList = (nsFriendsList as AnyObject)
                        self.parameters["friendsList"] = friendsList
                        print("checking parameters: \(self.parameters)")
                        friendsNames = self.getFriends(nsFriendsList)
                    }
                    
                    let pageVC = self.storyboard?.instantiateViewControllerWithIdentifier("PageVC") as! PageVC
                    pageVC.parameters = self.parameters
                    var truthyFriendsList:[String:Bool] = [String:Bool]()
                    //add temp truthy vals
                    //will begin polling in the mainVC
                    for userName in friendsNames!{
                        truthyFriendsList[userName] = false
                    }
                    
                    //creating the concrete User
                    pageVC.user = User(firstName: JSON["firstName"] as! String, lastName: JSON["lastName"] as! String, username: self.username!.text!, status: true, friendsList: truthyFriendsList, eventsList: [])
                    self.presentViewController(pageVC, animated: true, completion: nil)
                    
                }else{
                    //Invalid login
                    self.alertController = UIAlertController(title: "Failed Authentication", message: "Invalid Username or Password", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in}
                    self.alertController!.addAction(okAction)
                    self.presentViewController(self.alertController!, animated: true, completion:nil)
                    
                }
        }
    }
    
    //Convert generic array to string array who made this?
    //@recoil and @andy
    func getFriends(friends: NSArray) -> [String]{
        var friendsToReturn:[String] = [String]()
        for name in friends {
            friendsToReturn.append(name as! String)
        }
        return friendsToReturn
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
