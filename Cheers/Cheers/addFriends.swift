//
//  addFriends.swift
//  Cheers
//
//  Created by Cheng yuan Ma on 3/29/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Alamofire

class addFriends: UIViewController {

    
    @IBOutlet weak var friendTxt: UITextField!
    var alertController:UIAlertController?=nil
    var currentLoggedInUser:String!
    var status:Bool!
    var thePass:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("in addFriends: \(self.currentLoggedInUser)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addbtn(sender: AnyObject) {
        
        
        
        friendTxt.text = friendTxt.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        var userExists:Bool = false
        
        Alamofire.request(.GET, "https://morning-crag-80115.herokuapp.com/cheers_user/exists/\(self.friendTxt!.text!)")
            .responseJSON { response in
                //request is original URL request
                //response is URL response
                //data is server data/payload
                //result is response of serialization
                userExists = response.result.value!["exists"] as! Bool
                self.addFriend(userExists)
            }
    }
    
    func addFriend(userExists:Bool){
        if userExists {
            //Use CORE Data to instantiate this user object if it doesn't already exist?
            let theParameters = [
                "username": self.currentLoggedInUser!, //logged in user
                "friend" : self.friendTxt!.text! //user to be added that we know already exists!
            ]
            print(theParameters["username"])
            print(theParameters["friend"])
            
            
            //post to backend to register the user
            Alamofire.request(.POST, "https://morning-crag-80115.herokuapp.com/add_friend/", parameters: theParameters, encoding: .JSON).responseJSON { response in
                if let JSON = response.result.value{
                    print(JSON)
                }
            }
            
            self.alertController = UIAlertController(title: "Friend Added!", message: "\(self.friendTxt!.text!) has been successfully added!", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
                let main = self.storyboard?.instantiateViewControllerWithIdentifier("PageVC") as! PageVC
                main.loggedInUserName = self.currentLoggedInUser
                main.pass = self.thePass
                main.theStatus = self.status
                self.presentViewController(main, animated: true, completion: nil)
            }
            
            self.alertController!.addAction(okAction)
            self.presentViewController(self.alertController!, animated: true, completion:nil)
            
            
        }else{
            self.alertController = UIAlertController(title: "Error!", message: "Friend was not found", preferredStyle: UIAlertControllerStyle.Alert)
            
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
            page.loggedInUserName = self.currentLoggedInUser
            page.theStatus = self.status
            page.pass = self.thePass
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
