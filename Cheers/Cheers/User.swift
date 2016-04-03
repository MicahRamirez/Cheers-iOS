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
    var friendsList:[String:Bool]? = nil
    
    ///init
    /// Default constructor for User data model
    init(firstName:String, lastName:String, username:String, status:Bool, friendsList:[String:Bool]) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.status = status
        self.friendsList = friendsList
    }
    
    ///getFriendsList
    /// getter for the friendsList instance variable
    func getFriendsList() -> [String:Bool] {
        return self.friendsList!
    }
}