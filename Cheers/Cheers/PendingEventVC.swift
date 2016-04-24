//
//  PendingEventVC.swift
//  Cheers
//
//  Created by Xavier Ramirez on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import QuartzCore

class PendingEventVC: UIViewController, UITableViewDataSource, UITableViewDelegate, PECellDelegate {
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
    
    /// numberOfRowsInSection - returns the number of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userDelegate!.pendingEventListSize()
    }
    
    /// cellForRowAtIndexPath
    ///  returns a configured custom cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PendingEventCell", forIndexPath: indexPath) as! PendingEventCell
        
        //Assign all cell variables
        let drinkEvent:DrinkEvent = userDelegate!.getPendingEvent(indexPath.row)
        cell.delegate = self
        cell.organizer!.text! = drinkEvent.getOrganizer()
        cell.location!.text! = drinkEvent.getLocation()
        cell.dateTime!.text! = drinkEvent.getDateTime()
        
        return cell;
    }
    
    /// cellTapped
    ///  delegate method that is called from the cell where the yes/no button is pressed
    func cellTapped(cell: PendingEventCell, accepted: Bool) {
        let indexPath = self.pendingDrinkTable.indexPathForRowAtPoint(cell.center)!
        let drinkEvent:DrinkEvent = userDelegate!.getPendingEvent(indexPath.row)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
