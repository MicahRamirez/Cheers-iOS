//
//  PageVC.swift
//  Cheers
//
//  Created by Xavier Ramirez on 3/18/16.
//  Sample code was translated from a tutorial and was used for the basis of this controller
//    Source: https://spin.atomicobject.com/2015/12/23/swift-uipageviewcontroller-tutorial/
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController {
	
	// MARK: - Outlets & Variables
    
    weak var pageDelegate: PageVC? = nil
    var user:UserDelegateProtocol?
    var colorConfig:UIColor?
    var autoDrink:Bool?
    var fromTime:UIDatePicker?
    var toTime:UIDatePicker?
    var settingVar: SettingVars? = nil
	
	// MARK: - Override Functions
	
	override func viewDidLoad() {
		super.viewDidLoad()
		dataSource = self
		pageDelegate = self
		
		//set the first VC to render
		if let firstViewController = orderedViewControllers.first {
			setViewControllers([firstViewController],
			                   direction: .Forward,
			                   animated: true,
			                   completion: nil)
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// MARK: - Actions
	
	@IBAction func unwindToVC(segue: UIStoryboardSegue) {
	}
	
	// MARK: - Helper Methods
	
    //View controllers to be used by this PageController
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.createMainVC(),self.createPendingEventVC() ,self.createAcceptedEventVC()]
    }()
    
    /// createMainVC
    /// grabs a reference and instantiates an item on the storyboard
    private func createMainVC() -> UIViewController {
        
        let main = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainVC") as! MainVC
        //passing instance of the user that conforms to the protocol to the mainVC
        main.user = self.user
        
        if self.settingVar != nil {
            main.settingVar = self.settingVar
        }
        
        return main
    }
    
    /// createPendingEventVC
    /// grabs a reference and instantiates an item on the storyboard
    private func createPendingEventVC() -> UIViewController {
        let pendingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PendingVC") as! PendingEventVC
        pendingVC.colorConfig = self.colorConfig
        //assigning the delegate for the pendingVC
        pendingVC.userDelegate = user
        pendingVC.settingVar = self.settingVar
        
        return pendingVC
    }
    
    /// createAcceptedEventVC
    /// grabs a reference and instantiates an item on the storyboard
    private func createAcceptedEventVC() -> UIViewController {
        
        let acceptedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AcceptedVC") as! AcceptedEventVC
        acceptedVC.colorConfig = self.colorConfig
        acceptedVC.userDelegate = user
        acceptedVC.settingVar = self.settingVar
        
        return acceptedVC
    }
	
	// MARK: - Navigation
	
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
    }
}

// MARK: - Extension

//extension of the PageVC class
//implements the UIPageViewControllerDataSource
extension PageVC : UIPageViewControllerDataSource {
	
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
                return nil
            }
            
            var previousIndex = 0
            
            //on MainVC previous in PendingVC
            if viewControllerIndex == 0{
                previousIndex = 1
            }else if viewControllerIndex == 1 {
                //on PendingVC previous is MainVC
                return nil
            }else if viewControllerIndex == 2{
                //otherwise on Accepted VC and prev is MainVC
                previousIndex = 0
            }
            
            return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            
            guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
                return nil
            }
            var nextIndex = 0
            if viewControllerIndex == 0{
                //at the main the next is acceptedVC
                nextIndex = 2
            }else if viewControllerIndex == 1 {
                //at the PendingVC next is mainVC
                nextIndex = 0
            }else if viewControllerIndex == 2{
                //at the AcceptedVC next is nil
                return nil
            }
            
            return orderedViewControllers[nextIndex]
    }
}