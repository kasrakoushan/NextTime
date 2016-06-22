//
//  PersistenceManager.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-06-22.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import Foundation

class PersistenceManager {
    // return the user's documents directory
    class func documentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentDirectory = paths[0]
        return documentDirectory
    }
}