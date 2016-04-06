//
//  MainVC.swift
//  Cheers
//
//  Created by Xavier Ramirez on 3/16/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var offMessage: UILabel!
    @IBOutlet weak var userStatus: UISwitch!
    @IBOutlet weak var userStatusImage: UIImageView!
    @IBOutlet weak var friendsList: UITableView!
    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var settings: UIButton!
    
    var user:User?
    var loggedInUser:String!
    var checkStatus:Bool?=nil
    var password:String!
    var parameters:[String: AnyObject] = [String:AnyObject]()
    var friends:[String]?=nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.checkStatus != nil) {
            self.userStatus.setOn(self.checkStatus!, animated: true)
        }
        
        //Rounding UI elements
        self.offMessage.layer.masksToBounds = true
        self.offMessage.layer.cornerRadius = 12.0
        
        self.logout.layer.masksToBounds = true
        self.logout.layer.cornerRadius = 7.0
        
        self.settings.layer.masksToBounds = true
        self.settings.layer.cornerRadius = 7.0
        
        
        print("Checking username: \(self.user!.username)")
        
        // Instantiates static data model
        //self.loadDataModel()
        
        
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
        print("inside loadDataModel")
        print(self.user!.getFriendsList())
//        self.getFriends()
//        print("checking FriendsList: \(self.user!.getFriendsList())")
//        self.loadFriends()
        //self.queryFriendsList(self.parameters)
    }
   
    
//        func getFriends() {
//    
//            Alamofire.request(.GET, "https://morning-crag-80115.herokuapp.com/login/\(self.loggedInUser!)/\(self.password!)")
//                .responseJSON { response in
//                    //request is original URL request
//                    //response is URL response
//                    //data is server data/payload
//                    //result is response of serialization
//                    //let val = response.result.value
//                    print("for debugging")
//                    let value = response.result.value!["friendsList"] as! NSArray
//                    for name in value {
//                        print(name as! String)
//                        self.user!.addFriend(name as! String)
//                        print(self.user!.getFriendsList())
//                        //listFriends.append(name as! String)
//                        //self.friends?.append(name as! String)
//                }
//            }
//           
//        }
    
//    func loadFriends() {
//        Alamofire.request(.GET, "https://morning-crag-80115.herokuapp.com/login/\(self.loggedInUser)/\(self.password)")
//            .responseJSON { response in
//                //request is original URL request
//                //response is URL response
//                //data is server data/payload
//                //result is response of serialization
//                if let JSON = response.result.value {
//                    //var parameters:[String:[String]] = [String:[String]]()
//                    if let nsFriendsList:NSArray =  JSON["friendsList"] as? NSArray{
//                        let friendsList = (nsFriendsList as! [String])
//                        self.parameters["friendsList"] = friendsList
//                    }
//                }
//        }
//    }
    
//    func queryFriendsList(parameters:[String:AnyObject]) {
//        print(parameters)
//        do {
//            let jsonData = try NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions.PrettyPrinted)
//            // here "jsonData" is the dictionary encoded in JSON data
//            Alamofire.request(.POST, "https://morning-crag-80115.herokuapp.com/fl_query/", parameters : parameters)
//                .responseJSON { response in
//                    print(response.result.value)
//                    if let res = response.result.value {
//                        print("this is res \(res)")
//                    }
//            }
//        } catch let error as NSError {
//            print(error)
//        }
//    }
    
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
        return self.user!.getFriendsList().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! FriendsTableViewCell
        
        
        
        let list = self.user!.getFriendsList()
        
        
        let person = list[indexPath.row]
        cell.nameLabel.text = person
        
        if self.user!.status == true {
            cell.statusIcon.image = UIImage(named: "Cheers-Logo")
        }
        else {
            cell.statusIcon.image = UIImage(named: "Cheers-Logo-Transparent")
        }
        
        // Configure the cell...
        //        let person = self.people[indexPath.row]
        
        // Sets full name
        //        cell.nameLabel.text = "\(person.firstName)" + " \(person.lastName)"
        //
        //        // Change image of friend's status if down to drink
        //        if person.status == true {
        //            cell.statusIcon.image = UIImage(named: "Cheers-Logo")
        //        }
        //        else {
        //            cell.statusIcon.image = UIImage(named: "Cheers-Logo-Transparent")
        //        }
        
        return cell
    }
    
    
    //prepare for segue for add friends
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toAddFriend") {
            let addFriendVC = segue.destinationViewController as! addFriends
            addFriendVC.currentLoggedInUser = self.loggedInUser
            addFriendVC.status = self.userStatus.on
            addFriendVC.thePass = self.password
            addFriendVC.user = self.user
        }
        else if(segue.identifier == "toSetting") {
            let setting = segue.destinationViewController as! settingsVC
            setting.status = self.userStatus.on
            setting.thePass = self.password
            setting.userName = self.loggedInUser
            setting.user = self.user
        }
    }
    
}
