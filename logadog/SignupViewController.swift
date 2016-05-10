//
//  SignupViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-09.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatTetField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("SignupViewController")
    }
    
    @IBAction func signupButtonTapped(sender: AnyObject) {
        // Todo:
        // 1. Check that password and repeat match
        // 2. Check that password is strong enough
        
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        let name = nameTextField.text!
        let email = emailTextField.text!
        
        let postString = "username=\(username)&password=\(password)&name=\(name)&email=\(email)"
        
        
//        let (jsonResponse, responseData) = ApiHelper.postJson(postString, ROUTE_USERS, VERB_POST)
//        let (jsonResponse, responseData) = ApiHelper.postJson(postString, route: ROUTE_USERS, verb: VERB_POST)
//        print(jsonResponse)
//        print(responseData)
        
    }
    
}
