//
//  Person.swift
//  Cheers
//
//  Created by Andy Tang on 3/23/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation

class User : UserDelegateProtocol {
    var firstName:String = "<not set>"
    var lastName:String = "<not set>"
    var username:String = "<not set>"
    var status:Bool = false
	
    //Username -> App Status
    var friendsList:[String:Bool]? = nil
	var eventsList:[DrinkEvent] = [DrinkEvent]()
    
	
    init(firstName:String, lastName:String, username:String, status:Bool, friendsList:[String:Bool], eventsList:[DrinkEvent]) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.status = status
        self.friendsList = friendsList
		self.eventsList = eventsList
    }
	
	// MARK: - Get Functions
	
	func getFirstName() -> String{
		return self.firstName
	}
	
	func getLastName() -> String{
		return self.lastName
	}
	
	func getUsername() -> String {
		return self.username
	}
	
	func isActive()-> Bool {
		return self.status
	}
	
	// switchStatus - flips the status from off to on and vice versa
	func switchStatus() {
		self.status = !self.status
	}
	
	// MARK: - Friends List
	
    func getFriendsList() -> [String:Bool] {
        return self.friendsList!
    }
	
    func addFriend(username: String, status: Bool) {
        self.friendsList![username] = status
    }
	
	func friendIsActive(name:String) -> Bool {
		return self.friendsList![name]!
	}
	
	// MARK: - Event Lists
	
	func getEventsList() -> [DrinkEvent] {
		return self.eventsList
	}
	
	func addEvent(event:DrinkEvent) {
		self.eventsList.append(event)
	}
	

}