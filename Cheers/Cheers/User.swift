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
	var pendingEventList:[DrinkEvent] = [DrinkEvent]()
    var acceptedEventList:[DrinkEvent] = [DrinkEvent]()
    
	
    init(firstName:String, lastName:String, username:String, status:Bool, friendsList:[String:Bool], pendingEventList:[DrinkEvent], acceptedEventList:[DrinkEvent]) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.status = status
        self.friendsList = friendsList
		self.pendingEventList = pendingEventList
        self.acceptedEventList = acceptedEventList
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
		return self.pendingEventList
	}
	
	func addEvent(event:DrinkEvent) {
		self.pendingEventList.append(event)
	}
    
    func pendingEventListSize() -> Int {
        return self.pendingEventList.count
    }
    
    func getPendingEvent(index: Int) -> DrinkEvent {
        return self.pendingEventList[index]
    }
    
    ///removePendingEvent
    /// removes the Event at the specified index
    func removePendingEvent(index:Int){
        self.pendingEventList.removeAtIndex(index)
    }
    
    ///addAcceptedEvent
    /// adds an event to the AcceptedEvent list
    func addAcceptedEvent(drinkEvent:DrinkEvent){
        self.acceptedEventList.append(drinkEvent)
    }
	
	// MARK: - Accepted Event
	
	func acceptedEventListSize() -> Int {
		return self.acceptedEventList.count
	}
	
	func getAcceptedEvent(index:Int) -> DrinkEvent {
		return self.pendingEventList[index]
	}
	
	func removeAcceptedEvent(index:Int) {
		self.acceptedEventList.removeAtIndex(index)
	}
}