//
//  StartViewController.swift
//  logadog
//
//  Created by Henrik Fogelberg on 2016-04-28.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class StartViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hasToken = hasLoginToken()
        if hasToken == true {
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("dogsListSegue", sender: self)
            }
        }
    }
    
    func hasLoginToken() -> Bool {
        let token: String? = KeychainWrapper.stringForKey(KEYCHAIN_TOKEN)
        print(token)
        
        if (token != nil) {
            return true
        } else {
            return false
        }
    }
}
