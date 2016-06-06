//
//  MedicationViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-06-06.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class MedicationViewController: UIViewController {
    
    @IBOutlet weak var productTypetextfield: UITextField!
    @IBOutlet weak var makeTextfield: UITextField!
    @IBOutlet weak var amountTextfield: UITextField!
    @IBOutlet weak var costTextfield: UITextField!
    @IBOutlet weak var reminderTextfield: UITextField!
    @IBOutlet weak var commentTextview: UITextView!
    
    var dogId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        var productType = ""
        var make = ""
        var amount = ""
        var cost = ""
        var reminder = ""
        var comment = ""
        
        if let productVal = self.productTypetextfield.text as String? {
            productType = productVal
        }
        
        if let makeVal = self.makeTextfield.text as String? {
            make = makeVal
        }
        
        if let amountVal = self.amountTextfield.text as String? {
            amount = amountVal
        }
        
        if let costVal = self.costTextfield.text as String? {
            cost = costVal
        }
        
        if let reminderVal = self.reminderTextfield.text as String? {
            reminder = reminderVal
        }
        
        if let commentVal = self.commentTextview.text as String? {
            comment = commentVal
        }
        
        let medication = [
            "productType": productType,
            "make": make,
            "amount": amount,
            "cost": cost,
            "reminder": reminder,
            "comment": comment,
            "dogid": self.dogId,
            "token": TokenController.getToken()
        ]
        
        RestApiManager.sharedInstance.postRequest(ROUTE_MEDICATION, params: medication, onCompletion: {(json: JSON) -> () in
            var status = STATUS_OK
            
            print(json)
            
            if let statusVal = json["status"].rawString() as String? {
                status = Int(statusVal)!
            }
            
            if status == STATUS_OK {
                dispatch_async(dispatch_get_main_queue()) {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            } else {
                // ToDo: Dsiplay error message
                print("ERROR: \(status)")
            }
        })
        
    }
}
