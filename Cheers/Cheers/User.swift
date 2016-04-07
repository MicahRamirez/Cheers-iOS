//
//  Person.swift
//  Cheers
//
//  Created by Andy Tang on 3/23/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation

class User {
    var firstName:String = "<not set>"
    var lastName:String = "<not set>"
    var username:String = "<not set>"
    var status:Bool = false
	
    //Username -> App Status
    var friendsList:[String]? = nil
	var eventsList:[DrinkEvent] = [DrinkEvent]()
    
    // MARK: - Constructors
	
	init(firstName:String, lastName:String, username:String, status:Bool, friendsList:[String], eventsList:[DrinkEvent]) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.status = status
        self.friendsList = friendsList
		self.eventsList = eventsList
    }
	
	// MARK: - Friends List
	
    func getFriendsList() -> [String] {
		return self.friendsList!
	}
	
    func addFriend(username: String) {
		self.friendsList!.append(username)
	}
	
    func getUsername() -> String {
		return self.username
	}
	
	// MARK: - Event Lists
	
	func getEventsList() -> [DrinkEvent] {
		return self.eventsList
	}
	
	func addEvent(event:DrinkEvent) {
		self.eventsList.append(event)
	}
	
	
}