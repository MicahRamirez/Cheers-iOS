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

	// MARK: - Outlets & Class Instance
	
    @IBOutlet weak var offMessage: UILabel!
    @IBOutlet weak var userStatus: UISwitch!
    @IBOutlet weak var userStatusImage: UIImageView!
    @IBOutlet weak var friendsList: UITableView!
    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var settings: UIButton!
    
    var user:UserDelegateProtocol?
    var colorConfig:UIColor?
    weak var timer:NSTimer?
    weak var timer1:NSTimer?
    var autoDrink:Bool?
    var fromTime:UIDatePicker?
    var toTime:UIDatePicker?
	
	// MARK: - Override Functions
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.friendsList.delegate = self
        self.friendsList.dataSource = self
        //if the user's status is active then set it as ON
        self.userStatus.setOn(self.user!.isActive(), animated: true)
        if self.user!.isActive() {
            //the user is active show the table and hide the off message
            userStatusImage.image = UIImage(named: "Cheers-Logo")
            friendsList.hidden = false
            offMessage.hidden = true
        }
        else {
            userStatusImage.image = UIImage(named: "Cheers-Logo-Transparent")
            friendsList.hidden = true
            offMessage.hidden = false
        }
        
        //Rounding UI elements
        self.offMessage.layer.masksToBounds = true
        self.offMessage.layer.cornerRadius = 12.0
        
        self.logout.layer.masksToBounds = true
        self.logout.layer.cornerRadius = 7.0
        
        self.settings.layer.masksToBounds = true
        self.settings.layer.cornerRadius = 7.0
		
        // Cuts extra footer
        friendsList.tableFooterView = UIView()
        
        if colorConfig != nil {
            self.view.backgroundColor = colorConfig
        }
        print("IN VIEW DID LOAD \(self.autoDrink)")
        self.pollForDate()
    }
    
    
    
    
    //turn off polling when the view disappears
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer!.invalidate()
    }
    
    //start the timer back up on return to the mainVC
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "pollFunc", userInfo: nil, repeats: true)
        self.timer1 = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "pollForDate", userInfo: nil, repeats: true)
    }
    
    func pollFunc() {
        //make friendslist query
        let parameters:[String:AnyObject] = [
            "friendsList": Array(self.user!.getFriendsList().keys),
            "username" : self.user!.getUsername()
        ]
        Alamofire.request(.POST, "https://morning-crag-80115.herokuapp.com/fl_query/", parameters: parameters, encoding: .JSON).responseJSON { response in
            if let JSON = response.result.value {
                //Ideally the response is Name->Status
                //pass result to userDelegate
                self.user!.updateFLStatus(JSON as! [String:Bool])
                //reload changes
                self.friendsList.reloadData()
            }
        }
    }
    
    func pollForDate() {
        
        print("IN POLLING: \(self.autoDrink)")
        if self.autoDrink == true {
            
            let start = self.fromTime!.date
            let end = self.toTime!.date
            let currentDate = NSDate()
            
            print("current time: \(currentDate.localTime)")
            print("from time: \(start.localTime)")
            print("to time: \(end.localTime)")
            
            
            let startVsCurrent = currentDate.earlierDate(start)
            print("startVSCurrent: \(startVsCurrent.localTime)")
            let endVsCurrent = currentDate.earlierDate(end)
            print("endVSCurrent: \(endVsCurrent.localTime)")
            
            print("comparison current to start: \(startVsCurrent.isEqualToDate(start))")
            print("comparison curren to end: \(endVsCurrent.isEqualToDate(currentDate))")
            
            if startVsCurrent.isEqualToDate(start)==true && endVsCurrent.isEqualToDate(currentDate)==true {
                print("GOT HEREERER")
                self.userStatus.setOn(true, animated: false)
            }
            else {
                print("GOT HSHAOIHDOA")
                self.userStatus.setOn(false, animated: true)
            }
            self.view.setNeedsDisplay()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	// MARK: - Actions
	
    ///statusChange
    /// alters the state of UITableView or Label to hidden
    /// based on the userStatus boolean value
    @IBAction func statusChange(sender: AnyObject) {
        self.user!.switchStatus()
        
        // Changes the status image and show or hide table view
        if self.user!.isActive() {
            userStatusImage.image = UIImage(named: "Cheers-Logo")
            friendsList.hidden = false
            offMessage.hidden = true
        }
        else {
            userStatusImage.image = UIImage(named: "Cheers-Logo-Transparent")
            friendsList.hidden = true
            offMessage.hidden = false
        }
        let parameters:[String:AnyObject] = [
            "username" : self.user!.getUsername(),
            "status" : self.user!.isActive()
        ]
        //ideally this would be thrown onto the ASYNC QUEUE
        Alamofire.request(.POST, "https://morning-crag-80115.herokuapp.com/update_status", parameters: parameters,encoding:.JSON)
    }
	
	// MARK: - UITableView
    
    // numberOfSectionsInTableView - returns the number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // numberOfRowsInSection - returns the number of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.user!.getFriendsList().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! FriendsTableViewCell
        let list = Array(self.user!.getFriendsList().keys)
        let friend = list[indexPath.row]
        cell.nameLabel.text = friend

        //render correct image based on friend's status
        if self.user!.friendIsActive(friend){
            cell.statusIcon.image = UIImage(named: "Cheers-Logo")
        }
        else {
            cell.statusIcon.image = UIImage(named: "Cheers-Logo-Transparent")
        }
        return cell
    }
	
	// MARK: - Navigation
	
    // prepare for segue for add friends
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toAddFriend") {
            let addFriendVC = segue.destinationViewController as! addFriends
            addFriendVC.user = self.user
            addFriendVC.colorConfig = self.colorConfig
            addFriendVC.autoDrink = self.autoDrink
            addFriendVC.fromTime = self.fromTime
            addFriendVC.toTime = self.toTime
        }
        else if(segue.identifier == "toSetting") {
            let setting = segue.destinationViewController as! settingsVC
            setting.user = self.user
            setting.colorConfig = self.colorConfig
            setting.autoDrink = self.autoDrink
            setting.from = self.fromTime
            setting.to = self.toTime
        }
		else if(segue.identifier == "AddDrink") {
            let AddDrinkEventVC = segue.destinationViewController as! CreateDrinkEventVC
            AddDrinkEventVC.userDelegate = user
            AddDrinkEventVC.colorConfig = self.colorConfig
            AddDrinkEventVC.autoDrink = self.autoDrink
            AddDrinkEventVC.fromTime = self.fromTime
            AddDrinkEventVC.toTime = self.toTime
        }
    }
}

extension NSDate {
    var localTime: String {
        return descriptionWithLocale(NSLocale.currentLocale())
    }
}
