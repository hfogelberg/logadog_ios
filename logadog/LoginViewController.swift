//
//  LoginViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-10.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, APIControllerProtocol {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var api : APIController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors().backgoundColor()
    }
    
    @IBAction func loginTapped(sender: AnyObject) {
        var username = ""
        var password = ""
        
        if let usernameTxt = self.usernameTextField.text {
            username = usernameTxt
        }
        
        if let passwordTxt = self.passwordTextField.text {
            password = passwordTxt
        }
        
        if ((username != "") && (password != "")) {
            let postString = "username=\(username)&password=\(password)"
            
            self.api = APIController(delegate: self)
            self.api!.postJson(postString, route: "authenticate", verb: "POST")
        }
    }
    
    func didRecieveAPIResults(status: Int, message: String, results: NSDictionary) {
        if results.count > 0 {
            var token = ""
            var userName = ""
            var userId = ""
            
            if let tokenVal = results["token"] as? String {
                token = tokenVal
            }
            if let usernameVal = results["username"] as? String {
                userName = usernameVal
            }
            if let userIdVal = results["user_id"] as? String {
                userId = userIdVal
            }
            
            TokenController.saveTokenAndUser(token, userId: userId, userName: userName)
        }
    }
}
