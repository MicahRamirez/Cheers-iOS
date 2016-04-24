//
//  PECellProtocol.swift
//  Cheers
//
//  Created by Xavier Ramirez on 4/24/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation

protocol PECellDelegate {
    func cellTapped(cell:PendingEventCell, accepted:Bool);
}