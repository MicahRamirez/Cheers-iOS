//
//  LoginVC.swift
//  Cheers
//
//  Created by Xavier Ramirez on 3/16/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Alamofire

class LoginVC: UIViewController {
    
    var alertController:UIAlertController?=nil
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    @IBOutlet weak var cheersLogo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func authenticateUser(sender: AnyObject) {
        Alamofire.request(.GET, "https://morning-crag-80115.herokuapp.com/login/\(self.username!.text!)/\(self.password!.text!)")
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    //Use CORE Data to instantiate this user object if it doesn't already exist?
                    print("JSON: \(JSON)")
                    let main = self.storyboard?.instantiateViewControllerWithIdentifier("PageVC") as! PageVC
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
