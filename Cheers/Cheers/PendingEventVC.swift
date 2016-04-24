//
//  PendingEventVC.swift
//  Cheers
//
//  Created by Xavier Ramirez on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import QuartzCore

class PendingEventVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var userDelegate:UserDelegateProtocol? = nil
    
    @IBOutlet weak var pendingDrinkTable: UITableView!
    
    //designated by a setting in the options VC
    var colorConfig:UIColor?
    
    @IBOutlet weak var pendingDrinksHeader: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pendingDrinkTable.delegate = self
        self.pendingDrinkTable.dataSource = self
        //round out the label header
        self.pendingDrinksHeader.layer.masksToBounds = true
        self.pendingDrinksHeader.layer.cornerRadius = 12.0
        
        
        if colorConfig != nil {
            self.view.backgroundColor = colorConfig
        }
    }
    
    // MARK: - UITableView
    
    /// numberOfRowsInSection - returns the number of rows to the TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // numberOfRowsInSection - returns the number of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userDelegate!.pendingEventListSize()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PendingEventCell", forIndexPath: indexPath) as! PendingEventCell
        
        print(userDelegate!.getPendingEvent(indexPath.row))
        
        var drinkEvent:DrinkEvent = userDelegate!.getPendingEvent(indexPath.row)
        
        cell.organizer!.text! = drinkEvent.getOrganizer()
        cell.location!.text! = drinkEvent.getLocation()
        cell.dateTime!.text! = drinkEvent.getDateTime()
        
        return cell;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
