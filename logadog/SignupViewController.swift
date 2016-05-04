//
//  SignupViewController.swift
//  logadog
//
//  Created by Henrik Fogelberg on 2016-04-22.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SignupViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func signupButtonTapped(sender: AnyObject) {
        var running = false
        var message: String?
        var status: Int?
        var user_id: String?
        var token: String?
        
        let myUrl = NSURL(string: "\(API_ROUTE_URL)\(Routes.USERS)")
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "\(Verbs.POST)"
        
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        let name = nameTextField.text!
        let email = emailTextField.text!
        
        let postString = "username=\(username)&password=\(password)&name=\(name)&email=\(email)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            print("response = \(response)")
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            var err: NSError?
            do {
                let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                print(jsonDictionary)
                
                if let jsonDictionary:NSDictionary = jsonDictionary {
                    if let messageResponse = jsonDictionary["message"] as? String {
                        message = messageResponse
                    }
                    if let successResponse = jsonDictionary["success"] as? Int {
                        status = successResponse
                    }
                    if let userResponse = jsonDictionary["user_id"] as? String {
                        user_id = userResponse
                    }
                    if let tokenResponse = jsonDictionary["token"] as? String {
                        token = tokenResponse
                    }
                    running = false
                }
            } catch {
                print(err)
            }
        }
        
        running = true
        task.resume()
        
        while running {
            print("Running")
            sleep(1)
        }
        
        if status == TRUE {
            KeychainWrapper.setString(token!, forKey: KEYCHAIN_TOKEN)
            KeychainWrapper.setString(user_id!, forKey: KEYCHAIN_USER)
            
            
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("signupShowDogsSegue", sender: self)
            }
            
        } else {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}

