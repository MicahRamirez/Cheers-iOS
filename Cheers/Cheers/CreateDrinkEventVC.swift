//
//  CreateDrinkEventVC.swift
//  Cheers
//
//  Created by Xavier Ramirez on 4/3/16.
//  Copyright © 2016 cs378. All rights reserved.
//
import Alamofire
import UIKit

class CreateDrinkEventVC: UIViewController {

    // MARK: - Outlets
	
	@IBOutlet weak var eventNameText: UITextField!
	@IBOutlet weak var locationText: UITextField!
	@IBOutlet weak var timeText: UITextField!
	@IBOutlet weak var friendsList: UITableView!
	@IBOutlet weak var datePicker: UIDatePicker!
	
	// MARK: - Override Functions
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - Actions
	
	@IBAction func createDrinkEvent(sender: AnyObject) {
	}
}
