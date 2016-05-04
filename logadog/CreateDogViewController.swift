//
//  CreateDogViewController.swift
//  logadog
//
//  Created by Henrik Fogelberg on 2016-04-26.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class CreateDogViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var breedTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func createDogTapped(sender: AnyObject) {
        var token = ""
        var userId = ""
        var name = ""
        var breed = ""
        var running = false
        var message = ""
        var status = FALSE
        
        if let nameVal = self.nameTextField.text as String? {
            name = nameVal
        }
        
        if let breedVal = self.breedTextField.text as String? {
            breed = breedVal
        }
        
        if let tokenVal: String = KeychainWrapper.stringForKey(KEYCHAIN_TOKEN) {
            token = tokenVal
        }
        
        if let userIdVal: String = KeychainWrapper.stringForKey(KEYCHAIN_USER) {
            userId = userIdVal
        }
        
        if token != "" {
//            let myUrl = NSURL(string: "\(API_ROUTE_URL)\(Routes.DOGS)?token=\(token)&user_id=\(userId)&name=\(name)&breed=\(breed)")
//            let request = NSMutableURLRequest(URL:myUrl!)
//            request.HTTPMethod = "\(Verbs.POST)"
//            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
//            request.addValue("Token token=\(token!)", forHTTPHeaderField: "x-access-token")

            
            let myUrl = NSURL(string: "\(API_ROUTE_URL)\(Routes.DOGS)")
            let request = NSMutableURLRequest(URL:myUrl!)
            request.HTTPMethod = "\(Verbs.POST)"
            let postString = "token=\(token)&user_id=\(userId)&name=\(name)&breed=\(breed)"
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
                        
                        if status == TRUE {
                            // Redirect to Dog List
                            dispatch_async(dispatch_get_main_queue()) {
                                self.navigationController?.popViewControllerAnimated(true)
                            }
                        } else {
                            // ToDo: Show error alert
                            
                            print(message)
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
            
            
        } else {
            print("No Token!!")
            // ToDo: Show error message and redirect to Start
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
