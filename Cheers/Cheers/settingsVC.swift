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
import ContactsUI
class settingsVC: UIViewController {
    
    // MARK: - Class Instance/Variables & Outlets
    var user:UserDelegateProtocol?
    
    // Setting dependent variables
    var addressBook: ABAddressBookRef?
    var colorConfig:UIColor?
    var alertController:UIAlertController? = nil
    var autoDrink:Bool?
    var from:UIDatePicker?
    var to:UIDatePicker?
    var settingVar: SettingVars?
    
    @IBOutlet weak var autoDrinkBtn: UISwitch!
    @IBOutlet weak var fromTime: UIDatePicker!
    @IBOutlet weak var toTimer: UIDatePicker!
    
    
    
    
    
    // MARK: - Outlet Actions
    
    @IBAction func addContacts(sender: AnyObject) {
        
        // Request for Contacts Access
        switch ABAddressBookGetAuthorizationStatus(){
        case .Authorized:
            print("Already authorized")
            createAddressBook()
            self.getContacts()
            /* Access the address book */
        case .Denied:
            print("Denied access to address book")
        case .NotDetermined:
            createAddressBook()
            
            if let theBook: ABAddressBookRef = addressBook {
                ABAddressBookRequestAccessWithCompletion(theBook, {(granted: Bool, error: CFError!) in
                    if granted{
                        print("Access granted")
                       self.getContacts()
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
    
    
    @IBAction func resetBtn(sender: AnyObject) {
        
        self.alertController = UIAlertController(title: "Reset", message: "Are you sure you want to reset the settings?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
            self.autoDrinkBtn.setOn(false, animated: true)
            self.settingVar!.setAutoDrink(false)
            let VC = self.storyboard?.instantiateViewControllerWithIdentifier("loginScreen")
            self.settingVar!.setColor(VC!.view.backgroundColor)
//            self.colorConfig = VC!.view.backgroundColor
            self.view.backgroundColor = self.colorConfig
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default){ (action:UIAlertAction) in
        }
        self.alertController!.addAction(cancelAction)
        self.alertController!.addAction(okAction)
        self.presentViewController(self.alertController!, animated: true, completion:nil)
        
    }
    
    
    func getContacts() {
        
        let status = CNContactStore.authorizationStatusForEntityType(.Contacts)
        if status == .Denied || status == .Restricted {
            // user previously denied, so tell them to fix that in settings
            return
        }
        
        // open it
        
        let store = CNContactStore()
        store.requestAccessForEntityType(.Contacts) { granted, error in
            guard granted else {
                dispatch_async(dispatch_get_main_queue()) {
                    // user didn't grant authorization, so tell them to fix that in settings
                    print(error)
                }
                return
            }
            
            // get the contacts
            
            var contacts = [CNContact]()
            
            let request = CNContactFetchRequest(keysToFetch: [CNContactIdentifierKey, CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName)])
            do {
                try store.enumerateContactsWithFetchRequest(request) { contact, stop in
                    contacts.append(contact)
                }
            } catch {
                print(error)
            }
            
            // do something with the contacts array (e.g. print the names)
            
            let formatter = CNContactFormatter()
            formatter.style = .FullName
            var getContacts:[String] = [String]()
            for contact in contacts {
                getContacts.append(formatter.stringFromContact(contact)!)
            }
            let goToContactsVC = self.storyboard?.instantiateViewControllerWithIdentifier("addContacts") as! AddContactVC
            goToContactsVC.user = self.user
            goToContactsVC.AddrContacts = getContacts
            
            goToContactsVC.settingVar = self.settingVar
//            goToContactsVC.colorConfig = self.colorConfig
//            goToContactsVC.autoDrink = self.autoDrink
//            if self.autoDrink == true {
//                goToContactsVC.fromTime = self.fromTime
//                goToContactsVC.toTime = self.toTimer
//            }
            
            self.presentViewController(goToContactsVC, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if settingVar == nil {
            self.settingVar = SettingVars(colorConfig: nil, autoDrink: nil, from: nil, to: nil)
        }
        else {
            
            if self.settingVar!.getColor() != nil {
                self.view.backgroundColor = self.settingVar!.getColor()
            }
            if self.settingVar!.getAutoDrink() != nil {
                self.autoDrinkBtn.setOn(self.settingVar!.getAutoDrink()!, animated: true)
            }
            if self.settingVar!.getFromTime() != nil {
                self.fromTime.setDate((self.settingVar!.getFromTime()?.date)!, animated: true)
                self.toTimer.setDate((self.settingVar!.getToTime()?.date)!, animated: true)
            }
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
        
        self.settingVar!.setFromTime(self.fromTime)
        self.settingVar!.setToTime(self.toTimer)
        self.settingVar!.setAutoDrink(self.autoDrinkBtn.on)
        
        if(segue.identifier == "backFromSetting") {
            let page = segue.destinationViewController as! PageVC
            if self.user == nil {
                print("nil in settings")
            }
            page.user = self.user
            page.settingVar = self.settingVar
//            page.colorConfig = self.colorConfig
//            self.autoDrink = self.autoDrinkBtn.on
//            page.autoDrink = self.autoDrink
//            page.fromTime = self.fromTime
//            page.toTime = self.toTimer
        }
        else if(segue.identifier == "toColorPicker") {
            let VC = segue.destinationViewController as! colorPicker
            VC.user = self.user
            VC.settingVar = self.settingVar
//            VC.autoDrink = self.autoDrink
//            VC.toTime = self.toTimer
//            VC.fromTime = self.fromTime
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}