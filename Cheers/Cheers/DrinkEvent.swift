//
//  DrinkEvent.swift
//  Cheers
//
//  Created by Xavier Ramirez on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//
//	Data item that encapsulates information about a Drink Event
//	Initial data model for Drink Events
//	Attributes are self describing

import Foundation

class DrinkEvent : DrinkEventDelegateProtocol {
	
	// MARK: - Variables
	
	var organizer:String = "<not set>"
    var eventName:String = "<not set>"
	var location:String = "<not set>"
    var date:String = "<not set>"
	var invitedList:[String] = [String]()
	var attendedList:[String] = [String]()
	
	// MARK: - Constructor
	
	init(organizer:String, eventName:String, location:String, date:String, invitedList:[String], attendedList:[String]) {
        self.organizer = organizer
		self.eventName = eventName
		self.location = location
        self.date = date
		self.invitedList = invitedList
		self.attendedList = attendedList
    }
	
	// MARK: - Basic Methods
    
    ///getOrganizer
    /// returns the name:String of the organizer of the event
    func getOrganizer() -> String {
        return self.organizer
    }
    
    ///getLocation
    /// returns the location:String of the event
    func getLocation() -> String {
        return self.location
    }
    
    ///getDateTime
    /// returns the dateTime:String of the event
    func getDateTime() -> String {
        return self.date
    }
    
    ///getEventName
    /// returns the eventName:String of the event
    func getEventName() -> String {
        return self.eventName
    }
}
