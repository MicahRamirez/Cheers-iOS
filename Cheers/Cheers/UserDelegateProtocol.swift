//
//  UserDelegateProtocol.swift
//  Cheers
//
//  Created by Xavier Ramirez on 4/8/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation

protocol UserDelegateProtocol {
    
    /// getFriendsList
    /// returns a list of String:Boolean
    func getFriendsList() -> [String:Bool]
    
    /// getUserName
    /// returns the User's username
    func getUsername()->String;
    
    /// isActive
    /// returns the user's status
    func isActive()->Bool;
    
    /// addFriend
    /// adds a friend to the friendsList
    func addFriend(username: String, status: Bool);
    
    /// getFirstName
    /// returns  User's first name
    func getFirstName()->String;
    
    /// getLastName
    /// returns User's last name
    func getLastName()->String;
    
    /// friendIsActive
    /// checks the [String:Bool] for the friends status
    func friendIsActive(name:String)->Bool;
    
}