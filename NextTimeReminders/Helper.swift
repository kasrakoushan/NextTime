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
    class func generateBarButtonWithImage(imageName: String, action: Selector, target: AnyObject?) -> UIBarButtonItem {
        let button  = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: UIControlState())
        button.frame = CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0)
        button.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
}

class UIViewControllerWithCustomBackButton: UIViewController {
    
    override func viewDidLoad() {
        self.navigationItem.leftBarButtonItem = Helper.generateBarButtonWithImage(imageName: "back", action: #selector(UIViewControllerWithCustomBackButton.backButtonTapped), target: self)
    }
    
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
