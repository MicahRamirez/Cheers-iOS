//
//  MainVC.swift
//  Cheers
//
//  Created by Xavier Ramirez on 3/16/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import QuartzCore
import Alamofire

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var offMessage: UILabel!
    @IBOutlet weak var userStatus: UISwitch!
    @IBOutlet weak var userStatusImage: UIImageView!
    @IBOutlet weak var friendsList: UITableView!
    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var settings: UIButton!
    
    var people:[Person] = [Person]()
    var loggedInUser:String!
    var checkStatus:Bool?=nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.checkStatus != nil) {
            self.userStatus.setOn(self.checkStatus!, animated: true)
        }
        
        print("in Main: \(self.loggedInUser)")
        
        //Rounding UI elements
        self.offMessage.layer.masksToBounds = true
        self.offMessage.layer.cornerRadius = 12.0
        
        self.logout.layer.masksToBounds = true
        self.logout.layer.cornerRadius = 7.0
        
        self.settings.layer.masksToBounds = true
        self.settings.layer.cornerRadius = 7.0
        
        
        
        // Instantiates static data model
        self.loadDataModel()
        
        // Cuts extra footer
        friendsList.tableFooterView = UIView()
        
        // Initially sets the mug image to full or empty and hides list dependending on switch.
        if userStatus.on {
            userStatusImage.image = UIImage(named: "Cheers-Logo")
            friendsList.hidden = false
            offMessage.hidden = true
        }
        else {
            userStatusImage.image = UIImage(named: "Cheers-Logo-Transparent")
            friendsList.hidden = true
            offMessage.hidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    ///loadDataModel
    /// loads the data model for the UITableView
    func loadDataModel() {
        
        
        self.getFriends()
        
        self.people.append(Person(firstName: "Xavier", lastName: "Ramirez", username: "micahramirez", status: true))
        self.people.append(Person(firstName: "Jeff", lastName: "Ma", username: "recoil53", status: false))
        self.people.append(Person(firstName: "Andy", lastName: "Tang", username: "tang_andy", status: false))
    }
    
    func getFriends() /*-> [String]*/{
        
        Alamofire.request(.GET, "https://morning-crag-80115.herokuapp.com/add_friend")
            .responseJSON { response in
                //request is original URL request
                //response is URL response
                //data is server data/payload
                //result is response of serialization
                let val = response.result.value
                print(val)
                
        }

        
        
    }
    
    ///statusChange
    /// alters the state of UITableView or Label to hidden
    /// based on the userStatus boolean value
    @IBAction func statusChange(sender: AnyObject) {
        
        // Changes the status image and show or hide table view
        if userStatus.on {
            userStatusImage.image = UIImage(named: "Cheers-Logo")
            friendsList.hidden = false
            offMessage.hidden = true
        }
        else {
            userStatusImage.image = UIImage(named: "Cheers-Logo-Transparent")
            friendsList.hidden = true
            offMessage.hidden = false
        }
    }
    
    ///numberOfSectionsInTableView
    /// returns the number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    ///numberOfRowsInSection
    /// returns the number of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.people.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! FriendsTableViewCell
        
        // Configure the cell...
        let person = self.people[indexPath.row]
        
        // Sets full name
        cell.nameLabel.text = "\(person.firstName)" + " \(person.lastName)"
        
        // Change image of friend's status if down to drink
        if person.status == true {
            cell.statusIcon.image = UIImage(named: "Cheers-Logo")
        }
        else {
            cell.statusIcon.image = UIImage(named: "Cheers-Logo-Transparent")
        }
        
        return cell
    }
    
    
    //prepare for segue for add friends
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toAddFriend") {
            let addFriendVC = segue.destinationViewController as! addFriends
            addFriendVC.currentLoggedInUser = self.loggedInUser
            addFriendVC.status = self.userStatus.on
        }
        else if(segue.identifier == "toSetting") {
            let setting = segue.destinationViewController as! settingsVC
            setting.status = self.userStatus.on
        }
    }
    
}
