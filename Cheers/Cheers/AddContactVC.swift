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
	
	// MARK: - Outlets & Variables
	
    @IBOutlet weak var AllContacts: UITableView!
    var AddrContacts:[String] = [String]()
    var user:UserDelegateProtocol?
    var colorConfig:UIColor?
    var autoDrink:Bool?
    var addedContacts:[String] = [String]()
    var alertController:UIAlertController?
    var fromTime:UIDatePicker?
    var toTime:UIDatePicker?
    var settingVar: SettingVars?
    
	// MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.AllContacts!.backgroundColor! = UIColor(red: 205/255, green: 161/255, blue: 89/255, alpha: 1.0)
        self.AllContacts.delegate = self
        self.AllContacts.dataSource = self
        
        // Cuts extra footer
        AllContacts.tableFooterView = UIView()
        
        if self.settingVar != nil {
            if self.settingVar!.getColor() != nil {
                self.view.backgroundColor = self.settingVar!.getColor()
                self.AllContacts!.backgroundColor = self.settingVar!.getColor()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	// MARK: - Actions
	
	@IBAction func addBtn(sender: AnyObject) {
		
		for name:String in self.addedContacts {
			self.addFriendFromContact(name)
		}
		
		self.alertController = UIAlertController(title: "Friends Added!", message: "Friends have been successfully added!", preferredStyle: UIAlertControllerStyle.Alert)
		
		let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
		}
		
		self.alertController!.addAction(okAction)
		self.presentViewController(self.alertController!, animated: true, completion:nil)
	}
	
	@IBAction func goingBackBtn(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	// MARK: - Helper Methods
	
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
        
        //post to backend to register the user
        Alamofire.request(.POST, "https://morning-crag-80115.herokuapp.com/add_friend/", parameters: theParameters, encoding: .JSON).responseJSON { response in
            if let JSON = response.result.value{
                print(JSON)
            }
        }
        //THIS FRIEND HASN"T EVEN BEEN ADDED HOW WOULD IT BE IN THE FRIENDS LIST?????
        //Assumme it to be false initially
        user!.addFriend(friend, status: false)
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
        
        if self.settingVar != nil {
            if self.settingVar!.getColor() != nil {
                cell.spaceLbl!.backgroundColor = self.settingVar!.getColor()
            }
        }
        
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

}
