//
//  settingsVC.swift
//  Cheers
//
//  Created by Cheng yuan Ma on 3/30/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class settingsVC: UIViewController {

    var status:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "backFromSetting") {
            let page = segue.destinationViewController as! PageVC
            page.theStatus = self.status
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
