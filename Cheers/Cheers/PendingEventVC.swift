//
//  PendingEventVC.swift
//  Cheers
//
//  Created by Xavier Ramirez on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import QuartzCore

class PendingEventVC: UIViewController {
    let barNamesList:[String] = ["Crown and Anchor", "Spiderhouse", "Russian House"]
    let invitees:[String] = ["Josh", "Rita", "Lexi"]
    let timeDate:[String] = ["5PM 3/15/16", "5PM 3/23/16", "5PM 4/20/16"]
    var pendingEventList:[DrinkEvent] = [DrinkEvent]()
    
    @IBOutlet weak var pendingDrinksHeader: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //round out the label header
        self.pendingDrinksHeader.layer.masksToBounds = true
        self.pendingDrinksHeader.layer.cornerRadius = 12.0
        self.loadPendingDrinkEventDataModel()
    }
    
    ///loadPendingDrinkEventDataModel
    /// TODO load in data model
    func loadPendingDrinkEventDataModel(){
        var idx = 0
        for bar in barNamesList {
            self.pendingEventList.append(DrinkEvent(barName: bar, organizer: self.invitees[idx], timeDate: self.timeDate[idx]))
            idx += 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
