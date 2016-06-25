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
            
            RestApiManager.sharedInstance.postRequest(ROUTE_USERS, params: body, authenticated: false) {(json:JSON) -> () in
                var status = ""
                
                print(json)
                
                if let statusVal = json["status"].rawString() as String? {
                    status = statusVal
                }
                
                if status == STATUS_OK {
                    var userId = ""
                    var token = ""
                    
                    let user = json["user"]
                    
                    if let userVal = user["userId"].rawString() as String? {
                        userId = userVal
                    }
   
                    if let tokenVal = user["authToken"].rawString() as String? {
                        token = tokenVal
                    }
                    
                    TokenController.saveTokenAndUser(token, userId: userId)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("dogsListSegue", sender: self)
                    }
                    
                } else {
                    var message = ""
                    if let messageVal = json["message"].stringValue as String? {
                        message = messageVal
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
                        alertController.addAction(UIAlertAction(title: "Cacel", style: .Cancel, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
        } else {
            // Todo: Show allert etc
        }
    }
}
