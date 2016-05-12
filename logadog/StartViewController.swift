//
//  StartViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-09.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, APIControllerProtocol {
    var api : APIController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if TokenController.hasToken() {
            checkValidToken()
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
        }
    }
    
    func checkValidToken() {
        if let token = TokenController.getToken() {
            // There is a token. Check with the server that it's valid
            let postString = "token=\(token)"
            self.api = APIController(delegate: self)
            self.api!.getJson(postString, route: ROUTE_CHECK_TOKEN)
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
        }
    }
    
    func didRecieveAPIResults(status: Int, message: String, results: NSDictionary) {
        print("StartVC didRecieveAPIResults")
        if status == TRUE {
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("dogsListSegue", sender: self)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
            alert.addAction(okAction)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.presentViewController(alert, animated: true, completion: nil)
            }

        }
    }
}
