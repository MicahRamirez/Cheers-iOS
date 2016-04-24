//
//  DrinkEventDelegateProtocol.swift
//  Cheers
//
//  Created by Xavier Ramirez on 4/24/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation

protocol DrinkEventDelegateProtocol {
    
    ///getOrganizer
    /// returns the name:String of the organizer of the event
    func getOrganizer() -> String;
    
    ///getLocation
    /// returns the location:String of the event
    func getLocation() -> String;
    
    ///getDateTime
    /// returns the dateTime:String of the event
    func getDateTime() -> String;
    
    ///getEventName
    /// returns the eventName:String of the event
    func getEventName() -> String;
    
}