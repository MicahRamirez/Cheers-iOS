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
        print("VIEW LOADED")
        print(self.userDelegate!.pendingEventListSize())
    }
    
    // MARK: - UITableView
    
    /// numberOfRowsInSection - returns the number of rows to the TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // numberOfRowsInSection - returns the number of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("num rows")
        print(self.userDelegate!.pendingEventListSize())
        return self.userDelegate!.pendingEventListSize()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PendingEventCell", forIndexPath: indexPath) as! PendingEventCell
        
        print(userDelegate!.getPendingEvent(indexPath.row))
        
        cell.organizer!.text! = userDelegate!.getPendingEvent(indexPath.row).getOrganizer();
        
        return cell;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
