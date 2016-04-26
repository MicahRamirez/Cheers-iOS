//
//  AddContactVC.swift
//  Cheers
//
//  Created by Cheng yuan Ma on 4/21/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import ContactsUI

class AddContactVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var AddrContacts:[String] = [String]()
    var user:UserDelegateProtocol?
    var colorConfig:UIColor?
    
    @IBOutlet weak var AllContacts: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AllContacts.delegate = self
        self.AllContacts.dataSource = self
        if colorConfig != nil {
            self.view.backgroundColor = colorConfig
        }
        //self.getContacts()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func goingBackBtn(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - UITableView
    
    // numberOfSectionsInTableView - returns the number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // numberOfRowsInSection - returns the number of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.AddrContacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("addingContacts", forIndexPath: indexPath) as! addContactsCell
        let name = self.AddrContacts[indexPath.row]
        cell.nameLbl.text! = name
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! addContactsCell
        
        let imageOn = UIImage(named: "Dark-Blue-Button-filled-01.png")
        let imageOff = UIImage(named: "Dark-Blue-Button-01.png")
        
        
        if cell.count%2 == 0 {
            cell.checkBtn.setImage(imageOn, forState: .Normal)
        }
        else if cell.count%2 == 1 {
            cell.checkBtn.setImage(imageOff, forState: .Normal)
        }
        
        
        cell.count = cell.count + 1
        tableView.reloadData()
        
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
