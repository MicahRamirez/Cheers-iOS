//
//  PageVC.swift
//  Cheers
//
//  Created by Xavier Ramirez on 3/18/16.
//  Sample code from a tutorial was used with this controller...
//    Source: https://spin.atomicobject.com/2015/12/23/swift-uipageviewcontroller-tutorial/
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController {
    
    weak var pageDelegate: PageVC? = nil
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        // The view controllers will be shown in this order
        return [self.createMainVC(),self.createPendingEventVC() ,self.createAcceptedEventVC()]
    }()
    
    /// createMainVC
    /// grabs a reference and instantiates an item on the storyboard
    private func createMainVC() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewControllerWithIdentifier("MainVC")
    }
    
    private func createPendingEventVC() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PendingVC")
    }
    
    private func createAcceptedEventVC() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AcceptedVC")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        pageDelegate = self
        print("loaded PageVC")

        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                direction: .Forward,
                animated: true,
                completion: nil)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

    
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
                
                guard previousIndex >= 0 else {
                    return nil
                }
                
                guard orderedViewControllers.count > previousIndex else {
                    return nil
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
                    nextIndex = 2
                }else if viewControllerIndex == 1 {
                    nextIndex = 0
                }else if viewControllerIndex == 2{
                    return nil
                }
                
                let orderedViewControllersCount = orderedViewControllers.count
                    
                guard orderedViewControllersCount != nextIndex else {
                    return nil
                }
                    
                guard orderedViewControllersCount > nextIndex else {
                    return nil
                }
                    
                return orderedViewControllers[nextIndex]
        }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

