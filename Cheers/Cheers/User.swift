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
	
    ///getFriendsList
    /// getter for the friendsList instance variable
    func getFriendsList() -> [String:Bool] {
        return self.friendsList!
    }
    
    /// addFriend
    /// adds a friend to the friendsList
    func addFriend(username: String, status: Bool) {
        self.friendsList![username] = status
    }
    
    func getUsername() -> String {
        return self.username
    }
    
    /// getFirstName
    /// returns  User's first name
    func getFirstName()->String{
        return self.firstName
    }
    
    /// getLastName
    /// returns User's last name
    func getLastName()->String{
        return self.lastName
    }
    
    /// isActive
    /// returns the user's status
    func isActive()->Bool{
        return self.status
    }
    
    /// switchStatus
    /// flips the status from off to on and vice versa
    func switchStatus() {
        self.status = !self.status
    }
	
	// MARK: - Event Lists
	
	func getEventsList() -> [DrinkEvent] {
		return self.eventsList
	}
	
	func addEvent(event:DrinkEvent) {
		self.eventsList.append(event)
	}
    
    func friendIsActive(name: String) -> Bool {
        return self.friendsList![name]!
    }
}