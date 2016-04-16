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
	
	// MARK: - Outlets
	
    @IBOutlet weak var friendTxt: UITextField!
	
	// MARK: - Class Instances
	
    var alertController:UIAlertController? = nil
    var user:UserDelegateProtocol?
	
	// MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                if let JSON = response.result.value{
                    print(JSON)
                }
            }
            
            self.alertController = UIAlertController(title: "Friend Added!", message: "\(self.friendTxt!.text!) has been successfully added!", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
                let main = self.storyboard?.instantiateViewControllerWithIdentifier("PageVC") as! PageVC
                self.user!.addFriend(self.friendTxt!.text!, status:false)
                main.user = self.user
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
        }
    }
    
    
}
