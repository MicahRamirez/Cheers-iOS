//
//  DrinkEvent.swift
//  Cheers
//
//  Created by Xavier Ramirez on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation

//DrinkEvent
// data item that encapsulates information about a Drink Event
// Initial data model for Drink Events
// attributes are self describing
class DrinkEvent {
    var barName:String
    var organizer:String
    var timeDate:String
    
    init(barName:String, organizer:String, timeDate:String){
        self.barName = barName
        self.organizer = organizer
        self.timeDate = timeDate
    }
}
