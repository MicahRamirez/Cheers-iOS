//
//  Person.swift
//  Cheers
//
//  Created by Andy Tang on 3/23/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation

class Person {
    var firstName:String = "<not set>"
    var lastName:String = "<not set>"
    var username:String = "<not set>"
    var status:Bool = false
    
    init(firstName:String, lastName:String, username:String, status:Bool) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.status = status
    }
}