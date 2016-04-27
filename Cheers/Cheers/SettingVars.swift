//
//  SettingVars.swift
//  Cheers
//
//  Created by Cheng yuan Ma on 4/26/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation
import ContactsUI
import AddressBook

class SettingVars {
    
    var colorConfig:UIColor? = nil
    var autoDrink:Bool? = nil
    var from:UIDatePicker? = nil
    var to:UIDatePicker? = nil
    
    init(colorConfig: UIColor?, autoDrink: Bool?, from: UIDatePicker?, to: UIDatePicker?) {
        self.colorConfig = colorConfig
        self.autoDrink = autoDrink
        self.from = from
        self.to = to
    }
    
    func getColor() -> UIColor? {
        return self.colorConfig
    }
    
    func getAutoDrink() -> Bool? {
        return self.autoDrink
    }
    
    func getFromTime() -> UIDatePicker? {
        return self.from
    }
    
    func getToTime() -> UIDatePicker? {
        return self.to
    }
    
    func setColor(color: UIColor?) {
        self.colorConfig = color
    }
    
    func setAutoDrink(autoStatus: Bool?) {
        self.autoDrink = autoStatus
    }
    
    func setFromTime(fromTime: UIDatePicker?) {
        self.from = fromTime
    }
    
    func setToTime(toTime: UIDatePicker?) {
        self.to = toTime
    }
}