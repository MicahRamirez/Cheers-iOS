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
    var autoDrink:Bool = false
    var password:String = "<not set>"
	
    //Username -> App Status
    var friendsList:[String:Bool]? = nil
	var pendingEventList:[DrinkEvent] = [DrinkEvent]()
    var acceptedEventList:[DrinkEvent] = [DrinkEvent]()
    var referenceMap:[String:DrinkEvent] = [String:DrinkEvent]()
    
	
    init(firstName:String, lastName:String, username:String, status:Bool, friendsList:[String:Bool], pendingEventList:[DrinkEvent], acceptedEventList:[DrinkEvent], password:String) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.status = status
        self.friendsList = friendsList
		self.pendingEventList = pendingEventList
        self.acceptedEventList = acceptedEventList
        self.password = password
        for event in self.pendingEventList {
            referenceMap[event.getEventName()] = event
        }
//        self.autoDrink = autoDrink
    }
	
	// MARK: - Get Functions
	
    func setFriendsList(friends:[String:Bool]) {
        self.friendsList = friends
    }
    
    func getPass() -> String {
        return self.password
    }
    
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
	
    func setStatus(status:Bool) {
        self.status = status
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
    
    /// updateFLStatus - updates the friends list status'
    func updateFLStatus(friendsList:[String:Bool]){
       self.friendsList! = friendsList
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
    
    /// Bad design... Should not have a method be O(n^2) ideally we'd have a hash of name-> specific events app side
    // TODO ADD TO INTERFACE
    func eventAlreadyInPending(serverEventList:[DrinkEvent]) -> Bool{
        var shouldUpdate:Bool = false
        //go through this pendingEventList if we have gone through and the event isn't there yet
        for newEvent in serverEventList {
            print(newEvent.getEventName())
            if self.referenceMap[newEvent.getEventName()] == nil {
                print("WRONG")
                shouldUpdate = true
                self.addPendingEvent(newEvent)
            }
        }
        return shouldUpdate
    }
    
    func addPendingEvent(drinkEvent:DrinkEvent){
        self.pendingEventList.append(drinkEvent)
        self.referenceMap[drinkEvent.getEventName()] = drinkEvent
    }
    
    ///removePendingEvent
    /// removes the Event at the specified index
    func removePendingEvent(index:Int){
        let tmpDrinkEvent:DrinkEvent = self.pendingEventList[index]
        self.pendingEventList.removeAtIndex(index)
        self.referenceMap.removeValueForKey(tmpDrinkEvent.getEventName())
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
		return self.acceptedEventList[index]
	}
	
	func removeAcceptedEvent(index:Int) {
		self.acceptedEventList.removeAtIndex(index)
	}
}