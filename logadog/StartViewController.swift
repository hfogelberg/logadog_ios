//
//  StartViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-25.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let token = getToken()
        if !(token ?? "").isEmpty {
           let hasValidToken = tokenIsValid(token!)
            
            if hasValidToken == true {
                // There's a valid token. Show dogs list
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("dogsListSegue", sender: self)
                }
            } else {
                // There is a token, but it's expired. Log in again
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                }
            }
        }
    }
    
    func getToken() -> String? {
        var token = ""
        
        if let tokenVal = TokenController.getToken() as String? {
            token = tokenVal
        }
        
        return token
    }
    
    func tokenIsValid(token: String) -> Bool {
        var retVal = true
        let params = "token=\(token)"
        
        RestApiManager.sharedInstance.validateToken(params, onCompletion:  { (json: JSON) -> () in
            var status = STATUS_OK
            
            print(json)
            
            if let statusVal = json["status"].rawString() as String? {
                status = Int(statusVal)!
            }
            
            if status != STATUS_OK {
                // Todo: Show error message
                TokenController.removeTokenAndUser()
                retVal = false
            }
        })
        
        return retVal
    }
}
