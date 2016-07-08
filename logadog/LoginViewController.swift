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
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        
        view.backgroundColor = Colors.colorWithHexString(COLOR_BACKGROUND_VIEW)
        loginButton.setTitleColor(Colors.colorWithHexString(COLOR_BUTTON), forState: .Normal)
    }
    
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
            //let params = "username=\(username)&password=\(password)"
            let params:[String:String] = [
                "username": username,
                "password": password
            ]
            
            
            RestApiManager.sharedInstance.postRequest(ROUTE_AUTHENTICATE, params: params, authenticated: false) {(json:JSON) -> () in

                var status = STATUS_OK
                var message = ""
                
                if let statusVal = json["status"].numberValue as Int? {
                    status = statusVal
                }
                
                if let messageVal = json["message"].stringValue as String? {
                    message = messageVal
                }
                
                if status == STATUS_OK {
                    var userId = ""
                    var token = ""
                    
                    let user = json["data"]
                    
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
