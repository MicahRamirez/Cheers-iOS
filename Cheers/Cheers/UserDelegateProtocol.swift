//
//  UserDelegateProtocol.swift
//  Cheers
//
//  Created by Xavier Ramirez on 4/8/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation

protocol UserDelegateProtocol {
	
	// MARK: - Basic Methods
    
    /// sets the list of friends. Used when polling for the friends list
    func setFriendsList(friends:[String:Bool])
    
    /// returns password of user
    func getPass() -> String
    
    /// getFriendsList - returns a list of String:Boolean
    func getFriendsList() -> [String:Bool]
    
    /// getUserName - returns the User's username
    func getUsername()->String;
    
    /// isActive - returns the user's status
    func isActive()->Bool;
    
    /// addFriend - adds a friend to the friendsList
    func addFriend(username: String, status: Bool);
    
    /// getFirstName - returns  User's first name
    func getFirstName()->String;
    
    /// getLastName - returns User's last name
    func getLastName()->String;
    
    /// friendIsActive - checks the [String:Bool] for the friends status
    func friendIsActive(name:String)->Bool;
    
    /// setStatus - sets the status of user to passed in parameter
    func setStatus(status:Bool)
    
    /// switchStatus - flips the status from off to on and vice versa
    func switchStatus();
    
    /// updateFLStatus - updates the friends list status'
    func updateFLStatus(friendsList:[String:Bool]);
	
	// MARK: - Event Lists
	
	func getEventsList() -> [DrinkEvent];
	
	func addEvent(event:DrinkEvent);
	
	// MARK: - Pending Events
    
    func pendingEventListSize() -> Int;
    
    func getPendingEvent(index:Int) -> DrinkEvent;
	
    func removePendingEvent(index:Int);
	
	func eventAlreadyInPending(serverEventList:[DrinkEvent]) -> Bool;

	// MARK: - Accepted Event
	
	func acceptedEventListSize() -> Int;
	
	func getAcceptedEvent(index:Int) -> DrinkEvent;
	
	func addAcceptedEvent(drinkEvent:DrinkEvent);
	
	func removeAcceptedEvent(index:Int);
}