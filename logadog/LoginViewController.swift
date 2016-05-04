//
//  LoginViewController.swift
//  logadog
//
//  Created by Henrik Fogelberg on 2016-04-26.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        var running = false
        var message = ""
        var success = 0
        var userId = ""
        var token = ""
        
        let myUrl = NSURL(string: "\(API_ROUTE_URL)\(Routes.AUTHENTICATE)")
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "\(Verbs.POST)"
        
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        let postString = "username=\(username)&password=\(password)"
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
                    if let messageVal = jsonDictionary["message"] as? String {
                        print(messageVal)
                        message = messageVal
                    }
                    
                    if let successVal = jsonDictionary["success"] as? Int {
                        success = successVal
                    }
                    
                    if let userIdVal = jsonDictionary["user_id"] as? String {
                        userId = userIdVal
                    }
                    
                    if let tokenVal =  jsonDictionary["token"] as? String {
                        token = tokenVal
                        print("Logged in. This is the token \(token)")
                        print("")
                    }
                    
                    running = false
                    
                    if success == TRUE {
                        print("Success. Saving token to Keychain")
                        print(token)
                        KeychainWrapper.setString(token, forKey: KEYCHAIN_TOKEN)
                        KeychainWrapper.setString(userId, forKey: KEYCHAIN_USER)
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.performSegueWithIdentifier("loginShowDogsSegue", sender: self)
                        }
                    } else {
                        print("Error")
                        print(message)
                        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                        dispatch_async(dispatch_get_main_queue()) {
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    }
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
    }
}
