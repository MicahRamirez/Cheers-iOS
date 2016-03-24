//
//  SlideMainVC.swift
//  Cheers
//
//  Created by Xavier Ramirez on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class SlideMainVC: SlideMenuController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("SlideMainVC") {
            self.mainViewController = controller
        }
        if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("SlideLeftVC") {
            self.leftViewController = controller
        }
        super.awakeFromNib()
    }
}
