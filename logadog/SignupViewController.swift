//
//  SignupViewController.swift
//  logadog
//
//  Created by Henrik Fogelberg on 2016-04-22.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func signupButtonTapped(sender: AnyObject) {
        let endpoint = "http://localhost:3000/api/users"
        let myUrl = NSURL(string: endpoint);let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        // Compose a query string
        let postString = "email=\(emailTextField.text)&username=\(usernameTextField.text)&password=\(passwordTextField.text)";
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("response = \(response)")
            
            // Print out response body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            //Let’s convert response sent from a server side script to a NSDictionary object:
            
            var err: NSError?
            //var myJSON = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error:&err) as? NSDictionary
            do {
                let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                print(jsonDictionary)
                if let jsonDictionary:NSDictionary = jsonDictionary {
                    // Now we can access value of First Name by its key
                    let message = jsonDictionary["message"] as? String
                    print("message: \(message)")
                }
            } catch {
                print(err)
            }
        }
        
        task.resume()
    }
}

