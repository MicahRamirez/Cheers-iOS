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
	
	// MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
