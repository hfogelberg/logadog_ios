//
//  LoginViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-25.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginbuttonTapped(sender: AnyObject) {
        var username = ""
        var password = ""
        
        if let usernameVal = usernameTextfield.text as String? {
            username = usernameVal
        }
        
        if let passwordVal = passwordTextfield.text as String? {
            password = passwordVal
        }
        
        if username != "" && password != "" {
            let params = "username=\(username)&password=\(password)"
            
            RestApiManager.sharedInstance.authenticate(params) { (json: JSON) -> () in
                var status = STATUS_OK
                
                print(json)
                
                if let statusVal = json["status"].rawString() as String? {
                    status = Int(statusVal)!
                }
                
                if status == STATUS_OK {
                    var userId = ""
                    var username = ""
                    var token = ""
                    
                    let user = json["user"]
                    
                    if let userVal = user["user_id"].rawString() as String? {
                        userId = userVal
                    }
                    if let usernameVal = user["username"].rawString() as String? {
                        username = usernameVal
                    }
                    if let tokenVal = user["token"].rawString() as String? {
                        token = tokenVal
                    }
                    
                    TokenController.saveTokenAndUser(token, userId: userId, userName: username)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("dogsListSegue", sender: self)
                    }
                    
                } else {
                    // Todo: Show allert etc
                }
            }
        } else {
            // Todo: Show allert etc
        }
    }
}
