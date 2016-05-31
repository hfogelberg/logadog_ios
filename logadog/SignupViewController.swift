//
//  SignupViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-25.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignupViewController: UIViewController {
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var usernameTexfield: UITextField!
    @IBOutlet weak var emailTexfield: UITextField!
    @IBOutlet weak var paswordTextfield: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.colorWithHexString(COLOR_BACKGROUND_VIEW)
        signupButton.setTitleColor(Colors.colorWithHexString(COLOR_BUTTON), forState: .Normal)
    }
    
    @IBAction func signupButtonTapped(sender: AnyObject) {
        var name = ""
        var username = ""
        var email = ""
        var password = ""
        
        if let nameVal = nameTextfield.text as String? {
            name = nameVal
        }
        
        if let usernameVal = usernameTexfield.text as String? {
            username = usernameVal
        }
        
        if let emailVal = emailTexfield.text as String? {
            email = emailVal
        }
        if let passwordVal = paswordTextfield.text as String? {
            password = passwordVal
        }
        
        if name != "" && username != "" && email != "" && password != "" {
            let body:[String:String] = [
                "name": name,
                "username": username,
                "email": email,
                "password": password
            ]
            
            RestApiManager.sharedInstance.postRequest(ROUTE_USERS, params: body) {(json:JSON) -> () in
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
