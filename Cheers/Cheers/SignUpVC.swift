//
//  SignUpVC.swift
//  Cheers
//
//  Created by Xavier Ramirez on 3/16/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Alamofire

class SignUpVC: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    var textFieldArr:[UITextField]? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldArr = [self.email, self.password, self.userName, self.lastName, self.firstName]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    ///verifySignUp
    /// verifies the input in text fields and if valid creates a user in CORE
    /// this data should also be sent to the MongoDB via POST
    /// user should be logged in if info is valid
    @IBAction func verifySignUp(sender: AnyObject) {
        let res = self.textFieldArr!.filter {$0.text! == ""}
        //if all fields have been entered with text
        if res.count == 0 {
            
            // for now not encrypting passwords RIP
            // these parameters are what is defined in the schema in the 
            // nodeJS/Express server. DO NOT CHANGE UNLESS YOU KNOW WHAT YOU
            // ARE DOING
            let parameters = [
                "firstName": self.firstName!.text!,
                "lastName" : self.lastName!.text!,
                "username" : self.userName!.text!,
                "password" : self.password!.text!,
                "email" : self.email!.text!
            ]
            
            //post to backend to register the user
            Alamofire.request(.POST, "https://morning-crag-80115.herokuapp.com/user_create", parameters: parameters, encoding: .JSON)
            
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
