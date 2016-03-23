//
//  MainVC.swift
//  Cheers
//
//  Created by Xavier Ramirez on 3/16/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

	// MARK: - Class Instance
	
	var people:[Person] = [Person]()

	// MARK: - Functions
	
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded MainVC")

		// Instantiates static data model
		self.loadDataModel()
		
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
		
        // Dispose of any resources that can be recreated.
    }
	
	func loadDataModel() {
		self.people.append(Person(firstName: "Xavier", lastName: "Ramirez", username: "micahramirez", status: false))
		self.people.append(Person(firstName: "Jeff", lastName: "Ma", username: "recoil53", status: false))
		self.people.append(Person(firstName: "Andy", lastName: "Tang", username: "tang_andy", status: false))
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return self.people.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! FriendsTableViewCell
		
		// Configure the cell...
		let person = self.people[indexPath.row]
		
		// Sets nameLabel and appends last name
		cell.nameLabel.text = "\(person.firstName)" + " \(person.lastName)"
		
		// TODO:  Need to change image of friend's status.
		//if person.status == true
		//cell.friendStatus.image = Cheers-Logo.png
		
		return cell
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
