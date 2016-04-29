//
//  StartViewController.swift
//  logadog
//
//  Created by Henrik Fogelberg on 2016-04-28.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hasToken = hasLoginToken()
        if hasToken == true {
            print("dogsListSegue")
            dispatch_async(dispatch_get_main_queue()) {
                [unowned self] in
                self.performSegueWithIdentifier("dogsListSegue", sender: self)
            }
        }
    }
    
    func hasLoginToken() -> Bool {
        let hasLogin = NSUserDefaults.standardUserDefaults().boolForKey("logadogLoginKey")
        
        if hasLogin {
            if let storedUsername = NSUserDefaults.standardUserDefaults().valueForKey("username") as? String {
                print(storedUsername)
            }
            return true
        } else {
            return false
        }
    }
}
