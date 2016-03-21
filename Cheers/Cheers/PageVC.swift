//
//  PageVC.swift
//  Cheers
//
//  Created by Xavier Ramirez on 3/18/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController {
    
    weak var pageDelegate: MainVC? = nil
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        // The view controllers will be shown in this order
        return [self.createMainVC()]
    }()
    
    /// createMainVC
    /// grabs a reference and instantiates an item on the storyboard
    private func createMainVC() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewControllerWithIdentifier("MainVC")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //        dataSource = self
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
                return nil
        }
        
        func pageViewController(pageViewController: UIPageViewController,
            viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
                return nil
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

