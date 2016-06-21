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
    var medication: MedicationObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.colorWithHexString(COLOR_BACKGROUND_VIEW)
        
        
        if medication != nil {
            self.showMedication()
        }
    }
    
    func showMedication() {
        self.productTypetextfield.text = self.medication.medicationType
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
        print("Edit button tapped")
        
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
            "productType": productType,
            "make": make,
            "amount": amount,
            "cost": cost,
            "reminder": reminder,
            "comment": comment,
            "dogid": self.dogId,
            "token": TokenController.getToken()
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
            
            print(json)
        })
    }
        
    func createMedication(medication: [String:String]) {
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
