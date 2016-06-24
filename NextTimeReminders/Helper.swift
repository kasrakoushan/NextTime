//
//  Helper.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-06-24.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    // generate a custom navigation bar button with the given image and action
    class func generateBarButtonWithImage(imageName imageName: String, action: Selector, target: AnyObject?) -> UIBarButtonItem {
        let button  = UIButton(type: .Custom)
        button.setImage(UIImage(named: imageName), forState: .Normal)
        button.frame = CGRectMake(0.0, 0.0, 30.0, 30.0)
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        return UIBarButtonItem(customView: button)
    }
}