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

    @IBOutlet weak var pendingDrinksHeader: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //round out the label header
        self.pendingDrinksHeader.layer.masksToBounds = true
        self.pendingDrinksHeader.layer.cornerRadius = 12.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
