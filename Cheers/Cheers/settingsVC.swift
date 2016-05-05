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
import Alamofire
class settingsVC: UIViewController {
    
    // MARK: - Outlets & Variables
	
	@IBOutlet weak var autoDrinkBtn: UISwitch!
	@IBOutlet weak var fromTime: UIDatePicker!
	@IBOutlet weak var toTimer: UIDatePicker!
    var user:UserDelegateProtocol?
    var addressBook: ABAddressBookRef?
    var colorConfig:UIColor?
    var alertController:UIAlertController? = nil
    var autoDrink:Bool?
    var from:UIDatePicker?
    var to:UIDatePicker?
    var settingVar: SettingVars?
    var alertController1:UIAlertController? = nil
    var alertController2:UIAlertController? = nil
	
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
	
    // MARK: - Outlet Actions
	
    @IBAction func changeEmailBtn(sender: AnyObject) {
		
        self.alertController1 = UIAlertController(title: "Update Email", message: "Enter new email", preferredStyle: .Alert)
        
        self.alertController1!.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = "enter new email here"
        })
		
        self.alertController1!.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let newEmail = self.alertController1!.textFields![0] as UITextField
            
            let parameters:[String:AnyObject] = [
                "username": self.user!.getUsername(),
                "newemail" : newEmail.text!,
            ]
            // post to backend to register the user
            Alamofire.request(.POST, "https://morning-crag-80115.herokuapp.com/change_email", parameters: parameters, encoding: .JSON)
            
            self.alertController2 = UIAlertController(title: "Password Email", message: "Email has been updated!", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
                
            }
            self.alertController2!.addAction(okAction)
            self.presentViewController(self.alertController2!, animated: true, completion:nil)
        }))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
        }
        self.alertController1!.addAction(cancelAction)
        self.presentViewController(self.alertController1!, animated: true, completion: nil)
    }
	
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
            self.view.backgroundColor = self.settingVar!.getColor()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default){ (action:UIAlertAction) in
        }
        self.alertController!.addAction(cancelAction)
        self.alertController!.addAction(okAction)
        self.presentViewController(self.alertController!, animated: true, completion:nil)
    }
    
	// MARK: - Helper Methods
	
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
			
            var shortenedNameArray:[String] = [String]()
            for name:String in getContacts {
                let shortenedName:String = self.getOnlyFirstName(name)
                shortenedNameArray.append(shortenedName)
            }
            
            let theParameter = ["contactsList": shortenedNameArray]
            Alamofire.request(.POST, "https://morning-crag-80115.herokuapp.com/query_users_exist", parameters: theParameter, encoding: .JSON).responseJSON { response in
                if let JSON = response.result.value{
                    let namesArray:NSArray = JSON["existList"] as! NSArray
                    
                    let goToContactsVC = self.storyboard?.instantiateViewControllerWithIdentifier("addContacts") as! AddContactVC
                    goToContactsVC.user = self.user
                    goToContactsVC.AddrContacts = namesArray as! [String]
                    goToContactsVC.settingVar = self.settingVar
                    
                    self.presentViewController(goToContactsVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func getOnlyFirstName(name:String) -> String {
        
        var firstName:String = ""
        for char in name.characters {
            if String(char) == " " {
                return firstName
            }
            firstName += String(char)
        }
        return firstName
    }
    
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
            page.user = self.user
            page.settingVar = self.settingVar
        }
        else if(segue.identifier == "toColorPicker") {
            let VC = segue.destinationViewController as! colorPicker
            VC.user = self.user
            VC.settingVar = self.settingVar
        }
        else if (segue.identifier == "passChange") {
            let passVC = segue.destinationViewController as! changePass
            passVC.user = self.user
            passVC.settingVar = self.settingVar
        }
    }
}