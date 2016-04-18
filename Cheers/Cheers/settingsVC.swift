//
//  settingsVC.swift
//  Cheers
//
//  Created by Cheng yuan Ma on 3/30/16.
//  Copyright © 2016 cs378. All rights reserved.
//
//	Reference:  Requesting access to to the address book
//  http://ashishkakkad.com/2015/01/requesting-access-to-the-address-book-swift-language-ios-8/
//

import UIKit
import AddressBook

class settingsVC: UIViewController {
    
    // MARK: - Class Instance/Variables & Outlets
    var user:UserDelegateProtocol?
    
    // Setting dependent variables
    var addressBook: ABAddressBookRef?
    var colorConfig:UIColor?
    
    // MARK: - Outlet Actions
    
    @IBAction func addContacts(sender: AnyObject) {
        
        // Request for Contacts Access
        switch ABAddressBookGetAuthorizationStatus(){
        case .Authorized:
            print("Already authorized")
            createAddressBook()
            /* Access the address book */
        case .Denied:
            print("Denied access to address book")
        case .NotDetermined:
            createAddressBook()
            
            if let theBook: ABAddressBookRef = addressBook {
                ABAddressBookRequestAccessWithCompletion(theBook, {(granted: Bool, error: CFError!) in
                    if granted{
                        print("Access granted")
                    } else {
                        print("Access not granted")
                    }
                })
            }
            
        case .Restricted:
            print("Access restricted")
            
        default:
            print("Other Problem")
        }
    }
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(self.colorConfig)
        
        if self.colorConfig != nil {
             self.view.backgroundColor = colorConfig
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Other Functions
    
    func createAddressBook(){
        var error: Unmanaged<CFError>?
        addressBook = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "backFromSetting") {
            let page = segue.destinationViewController as! PageVC
            page.user = self.user
            page.colorConfig = self.colorConfig
        }
        else if(segue.identifier == "toColorPicker") {
            let VC = segue.destinationViewController as! colorPicker
            VC.user = self.user
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}