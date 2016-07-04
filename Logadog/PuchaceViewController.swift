//
//  PuchaceViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-06-26.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class PuchaceViewController: UIViewController {

    @IBOutlet weak var objectTextfield: UITextField!
    @IBOutlet weak var dateTextfield: UITextField!
    @IBOutlet weak var costTextfield: UITextField!
    @IBOutlet weak var commentTextview: UITextView!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var purchaseId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        var object = ""
        var date = ""
        var cost = ""
        var comment = ""
        
        if let objectVal = objectTextfield.text as String? {
            object = objectVal
        }
        
        if let dateVal = dateTextfield.text as String? {
            date = dateVal
        }
        
        if let costVal = costTextfield.text as String? {
            cost = costVal
        }
        
        if let commentVal = commentTextview.text as String? {
            comment = commentVal
        }
        
        let purchase = [
            "object": object,
            "date": date,
            "cost": cost,
            "comment": comment
        ]
        
        var route = ""
        if purchaseId != "" {
            route = "\(ROUTE_PURCHACE)/\(self.purchaseId)"
            
        } else {
            route = "\(ROUTE_PURCHACE)"
        }
        
        RestApiManager.sharedInstance.postRequest(route, params: purchase, onCompletion: {(json: JSON) -> () in
            var status = STATUS_OK
            
            if let statusVal = json["status"].numberValue as Int? {
                status = statusVal
            }
            
            if status == STATUS_OK {
                dispatch_async(dispatch_get_main_queue()) {
                    self.navigationController?.popViewControllerAnimated(true)
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
        })
    }
    
    @IBAction func editButtonTapped(sender: AnyObject) {
    
    }
}
