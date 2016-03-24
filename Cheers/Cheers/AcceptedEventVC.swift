//
//  AcceptedEventVC.swift
//  Cheers
//
//  Created by Xavier Ramirez on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import QuartzCore

class AcceptedEventVC: UIViewController {
    
    @IBOutlet weak var acceptedEventHeader: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.acceptedEventHeader.layer.masksToBounds = true
        self.acceptedEventHeader.layer.cornerRadius = 12.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
