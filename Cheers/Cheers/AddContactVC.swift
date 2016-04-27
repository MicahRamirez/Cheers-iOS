//
//  AddContactVC.swift
//  Cheers
//
//  Created by Cheng yuan Ma on 4/21/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import ContactsUI
import Alamofire

class AddContactVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var AddrContacts:[String] = [String]()
    var user:UserDelegateProtocol?
    var colorConfig:UIColor?
    var autoDrink:Bool?
    var addedContacts:[String] = [String]()
    var alertController:UIAlertController?
    var succAddedContacts:[String] = [String]()
    var fromTime:UIDatePicker?
    var toTime:UIDatePicker?
    var settingVar: SettingVars?
    
    @IBOutlet weak var AllContacts: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AllContacts.delegate = self
        self.AllContacts.dataSource = self
        
        if self.settingVar != nil {
            if self.settingVar!.getColor() != nil {
                self.view.backgroundColor = self.settingVar!.getColor()
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getIndexOfRemoved(name:String) -> Int {
        for index in 0...(addedContacts.count-1) {
            if addedContacts[index] == name {
                return index
            }
        }
        return 0
    }
    
    func addFriendFromContact(friend:String) {
            
            let theParameters = [ "username": self.user!.getUsername(), //logged in user
                "friend" : friend //user to be added that we know already exists!
            ]
            
            print(theParameters["username"])
            print(theParameters["friend"])
            
            //post to backend to register the user
            Alamofire.request(.POST, "https://morning-crag-80115.herokuapp.com/add_friend/", parameters: theParameters, encoding: .JSON).responseJSON { response in
                if let JSON = response.result.value{
                    print(JSON)
                }
            }
            //THIS FRIEND HASN"T EVEN BEEN ADDED HOW WOULD IT BE IN THE FRIENDS LIST?????
            //Assumme it to be false initially
            user!.addFriend(friend, status: false)
            
            self.alertController = UIAlertController(title: "Friend Added!", message: "\(friend) has been successfully added!", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
//                let main = self.storyboard?.instantiateViewControllerWithIdentifier("PageVC") as! PageVC
//                self.user!.addFriend(friend, status:false)
//                main.user = self.user
//                main.colorConfig = self.colorConfig
//                self.presentViewController(main, animated: true, completion: nil)
            }
            
            self.alertController!.addAction(okAction)
            self.presentViewController(self.alertController!, animated: true, completion:nil)
    }
    
    @IBAction func addBtn(sender: AnyObject) {
        print(self.addedContacts)
        
        for name:String in self.addedContacts {
            //exists ? then add to friends list
            let newString = name.stringByReplacingOccurrencesOfString(" ", withString: "")
            Alamofire.request(.GET, "https://morning-crag-80115.herokuapp.com/cheers_user/exists/\(newString)").responseJSON {
                response in
                //result is response of serialization
                print("salidhaishashdaohdoah")
                print(response.result.value)
                let userExists = response.result.value!["exists"] as! Bool
                if userExists == true {
                    print("FOUND FRIENDS")
                    self.addFriendFromContact(name)
                    //self.succAddedContacts.append(name)
                }
                else {
                   self.succAddedContacts.append(name)
                }
            }
            print(self.succAddedContacts)
        }
        
        
    }
    
    
    @IBAction func goingBackBtn(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - UITableView
    
    // numberOfSectionsInTableView - returns the number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // numberOfRowsInSection - returns the number of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.AddrContacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("addingContacts", forIndexPath: indexPath) as! addContactsCell
        let name = self.AddrContacts[indexPath.row]
        
        
        cell.nameLbl.text! = name
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! addContactsCell
        
        let imageOn = UIImage(named: "Dark-Blue-Button-filled-01.png")
        let imageOff = UIImage(named: "Dark-Blue-Button-01.png")
        
        if cell.count%2 == 0 {
            cell.checkBtn.setImage(imageOn, forState: .Normal)
            self.addedContacts.append(cell.nameLbl.text!)
        }
        else if cell.count%2 == 1 {
            cell.checkBtn.setImage(imageOff, forState: .Normal)
            let removeIndex:Int = self.getIndexOfRemoved(cell.nameLbl.text!)
            self.addedContacts.removeAtIndex(removeIndex)
        }
        
        cell.count = cell.count + 1
        tableView.reloadData()
        
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
