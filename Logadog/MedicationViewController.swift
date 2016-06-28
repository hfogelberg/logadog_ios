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
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var dogId = ""
    var medication: MedicationObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.colorWithHexString(COLOR_BACKGROUND_VIEW)
        
        
        if medication != nil {
            self.showMedication()
        }
    }
    
    func showMedication() {
        self.productTypetextfield.text = self.medication.productType
        self.makeTextfield.text = self.medication.product
        self.amountTextfield.text = self.medication.amount
        self.costTextfield.text = self.medication.cost
        self.reminderTextfield.text = self.medication.reminderDate
        self.commentTextview.text = self.medication.comment
        
        self.productTypetextfield.borderStyle = .None
        self.makeTextfield.borderStyle = .None
        self.amountTextfield.borderStyle = .None
        self.costTextfield.borderStyle = .None
        self.reminderTextfield.borderStyle = .None
        
        self.productTypetextfield.enabled = false
        self.makeTextfield.enabled = false
        self.amountTextfield.enabled = false
        self.costTextfield.enabled = false
        self.reminderTextfield.enabled = false
    }
    
    @IBAction func editButtonTapped(sender: AnyObject) {
        self.productTypetextfield.enabled = true
        self.makeTextfield.enabled = true
        self.amountTextfield.enabled = true
        self.costTextfield.enabled = true
        self.reminderTextfield.enabled = true
        
        self.productTypetextfield.borderStyle = .RoundedRect
        self.makeTextfield.borderStyle = .RoundedRect
        self.amountTextfield.borderStyle = .RoundedRect
        self.costTextfield.borderStyle = .RoundedRect
        self.reminderTextfield.borderStyle = .RoundedRect
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
            "dogId": dogId,
            "productType": productType,
            "make": make,
            "amount": amount,
            "cost": cost,
            "reminder": reminder,
            "comment": comment
        ]
        
        if self.medication == nil {
            self.createMedication(medication)
        } else {
            self.updateMedication(medication)
        }
        
    }
    
    func updateMedication(medication: [String:String] ){
        let medicationId = self.medication.medicationId
        let route = "\(ROUTE_MEDICATION)/\(medicationId)"
        
        RestApiManager.sharedInstance.postRequest(route, params: medication, onCompletion: {(json:JSON) -> () in
            var status = STATUS_OK
            
            if let statusVal = json["status"].numberValue as Int? {
                status = statusVal
            }
            
            if status == STATUS_OK {
                // ToDo!!!
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
    
    func createMedication(medication: [String:String]) {
        let route = "\(ROUTE_MY_PETS)/\(dogId)/\(ROUTE_MEDICATION)"
        RestApiManager.sharedInstance.postRequest(route, params: medication, onCompletion: {(json: JSON) -> () in
            var status = STATUS_OK
            print(json)
            
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
}
