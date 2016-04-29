//
//  LoginViewController.swift
//  logadog
//
//  Created by Henrik Fogelberg on 2016-04-26.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit

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
        let myUrl = NSURL(string: "\(API_ROUTE_URL)\(Routes.AUTHENTICATE)")
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "\(Verbs.POST)"
        let postString = "username=\(usernameTextField.text)&password=\(passwordTextField.text)"
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
                    let message = jsonDictionary["message"] as? String
                    let success = jsonDictionary["success"] as! Bool
                    let user_id = jsonDictionary["user_id"] as? String
                    let token = jsonDictionary["token"] as? String
                    print("message: \(message)")
                    
                    if success {
                        // Save username and password in Keychain
                        let hasLoginKey = NSUserDefaults.standardUserDefaults().boolForKey("logadogLoginKey")
                        if hasLoginKey == false {
                            NSUserDefaults.standardUserDefaults().setValue(user_id, forKey: "user_id")
                            NSUserDefaults.standardUserDefaults().setValue(token, forKey: "token")
                        }
                        
                        let MyKeychainWrapper = KeychainWrapper()
                        MyKeychainWrapper.mySetObject(self.passwordTextField.text, forKey:kSecValueData)
                        MyKeychainWrapper.writeToKeychain()
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "logadogLoginKey")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        print("We have a token!")
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            [unowned self] in
                            self.performSegueWithIdentifier("loginShowDogsSegue", sender: self)
                        }
                        
                    } else {
                        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
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
    }
}
