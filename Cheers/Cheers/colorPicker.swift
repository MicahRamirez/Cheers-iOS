//
//  colorPicker.swift
//  Cheers
//
//  Created by Andy Tang on 4/5/16.
//  Copyright © 2016 cs378. All rights reserved.
//
//	Reference:  Add a color picker to an ios app
//	http://stackoverflow.com/questions/21981640/add-a-color-picker-to-an-ios-app
//

import UIKit

class colorPicker: UIViewController {
	
	// MARK: - Constants
	// RRGGBB hex colors in the same order as the image
	let colorArray = [ 0x000000, 0xfe0000, 0xff7900, 0xffb900, 0xffde00, 0xfcff00, 0xd2ff00, 0x05c000, 0x00c0a7, 0x0600ff, 0x6700bf, 0x9500c0, 0xbf0199, 0xffffff ]
    var user:UserDelegateProtocol?
    var autoDrink:Bool?
    
	// MARK: - Outlets
	@IBOutlet weak var colorView: UIView!
	@IBOutlet weak var colorSlider: UISlider!
    var fromTime:UIDatePicker?
    var toTime:UIDatePicker?
	
	// MARK: - Actions
	
	@IBAction func selectColor(sender: AnyObject) {
		colorView.backgroundColor = uiColorFromHex(colorArray[Int(colorSlider.value)])
	}
	
	// MARK: - Initial Override Functions
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - More Functions
	
	func uiColorFromHex(rgbValue: Int) -> UIColor {
		
		let red =   CGFloat((rgbValue & 0xFF0000) >> 16) / 0xFF
		let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 0xFF
		let blue =  CGFloat(rgbValue & 0x0000FF) / 0xFF
		let alpha = CGFloat(1.0)
		
		return UIColor(red: red, green: green, blue: blue, alpha: alpha)
	}
    
    
    @IBAction func cancelBtn(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
	
	// MARK: - Navigation
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		// Segue back to setting screen
		if segue.identifier == "colorSelectSeg" {
			let page = segue.destinationViewController as! settingsVC
			page.colorConfig = self.colorView.backgroundColor
            page.user = self.user
            page.autoDrink = self.autoDrink
            page.from = self.fromTime
            page.to = self.toTime
		}
	}
	
}
