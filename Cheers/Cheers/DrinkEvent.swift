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

class DrinkEvent {
    //instance vars
	var organizer:String = "<not set>"
    var eventName:String = "<not set>"
	var location:String = "<not set>"
    var date:String = "<not set>"
	var invitedList:[User] = [User]()
	var attendedList:[User] = [User]()
    
    ///DrinkEvent
    /// drink event constructor
	init(organizer:String, eventName:String, location:String, date:String, invitedList:[User], attendedList:[User]) {
        self.organizer = organizer
		self.eventName = eventName
		self.location = location
        self.date = date
		self.invitedList = invitedList
		self.attendedList = attendedList
    }
}
